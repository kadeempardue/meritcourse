class DateRangeStudentLoginsCountWorker
  include Sidekiq::Worker

  def perform(start_date, end_date)
    ActsAsTenant.without_tenant do
      Tenant.all.each do |tenant|
        admin_emails = tenant.reporting_configs.where(email_type: "student-logins-count").pluck(:email)
        next unless admin_emails.present?

        results = {}
        start_date = DateTime.parse(start_date)
        end_date = DateTime.parse(end_date)

        (start_date.beginning_of_day..end_date.end_of_day).each do |date|
          start_of_this_date = date.beginning_of_day
          end_of_this_date = date.end_of_day
          day_events = Event.where(tenant_id: tenant.id, created_at: start_of_this_date..end_of_this_date, message_type: "online").where("uuid IS NOT NULL AND uuid != ''")
          if day_events.length.positive?
            day_student_uuids = day_events.pluck(:uuid).uniq.reject { |uuid| uuid.blank? }
            day_students = Student.where(uuid: day_student_uuids, tenant_id: tenant.id)

            day_students.each do |student|
              if results.key?(student.name)
                these_dates = day_events.pluck(:created_at).map { |t| t.strftime("%B %-d, %Y") }.uniq
                these_dates.each do |this_date|
                  unless results[student.name][:days].include?({ name: this_date })
                    results[student.name][:days].push({ name: this_date })
                    results[student.name][:count] = results[student.name][:count] + 1
                  end
                end
              else
                results[student.name] = { count: 0, days: [] }
              end
            end
          end
        end

        results = results.sort_by { |k,v| -v[:count] }.to_h.map { |k,v| { name: k}.merge(v) }

        postmark_service = PostmarkService.new(tenant)
        postmark_service.send_date_range_student_logins_count_email({ admin_emails: admin_emails, results: results, start_date: start_date.strftime("%B %-d, %Y"), end_date: end_date.strftime("%B %-d, %Y"), tenant: tenant, root_url: root_url(tenant) })
      end
    end
  end

  def root_url(tenant)
    if Rails.env.production?
      tenant.subdomain == "NULL" || tenant.subdomain.blank? ? "https://#{tenant.domain}" : "https://#{tenant.subdomain}.#{tenant.domain}"
    else
      "http://lvh.me:3000"
    end
  end
end
