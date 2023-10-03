class AverageParticipationRateWorker
  include Sidekiq::Worker

  def perform
    ActsAsTenant.without_tenant do
      Tenant.all.each do |tenant|
        admin_emails = tenant.reporting_configs.where(email_type: "average-participation-rate").pluck(:email)
        next unless admin_emails.present?

        email_ending = "@bostonk12.org"
        all_students = Student.all.select { |student| student.email.include?(email_ending) }
        count = all_students.count.to_f
        totals = []
        totals << ["Start Date", "End Date", "Students Active Today", "Total Students Enrolled", "Percentage of Students Active Today", "List of Students"]

        beginning = DateTime.new(2020, 10, 1)
        ending = Time.now.to_datetime

        (beginning...ending).each do |day|
          next if day.saturday? || day.sunday?
          beginning_of_this_day = day.beginning_of_day
          ending_of_this_day = day.end_of_day

          (beginning_of_this_day...ending_of_this_day).each do |this_day|

            student_uuids = Event.where(tenant_id: tenant.id, created_at: this_day.beginning_of_day..this_day.end_of_day, message_type: "online").where("uuid IS NOT NULL AND uuid != ''").pluck(:uuid).uniq.reject { |uuid| uuid.blank? }
            students = Student.where(uuid: student_uuids, tenant_id: tenant.id).select { |student| all_students.include?(student) }
            students_count = students.count
            next if students_count.zero?
            percent = students_count / count * 100
            puts "#{beginning_of_this_day} - #{ending_of_this_day} : #{students_count}/#{count} = #{'%.2f' % percent}%"
            totals << [beginning_of_this_day, ending_of_this_day, students_count, count, '%.2f' % percent, "#{students.map(&:name).join("|")}"]
          end
        end


        csv_file = CSV.generate do |writer|
          totals.each { |ar| writer << ar }
        end

        # File.write("#{Rails.root}/tmp/average_participation_rates_#{Time.now.to_s}.csv", csv_file)

        # postmark_service = PostmarkService.new(tenant)
        # postmark_service.send_daily_student_logins_email({ admin_emails: admin_emails, students: students, tenant: tenant, root_url: root_url(tenant), report_date: yesterday.strftime("%B %-d, %Y") })
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
