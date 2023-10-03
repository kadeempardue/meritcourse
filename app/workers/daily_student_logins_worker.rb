class DailyStudentLoginsWorker
  include Sidekiq::Worker

  def perform
    ActsAsTenant.without_tenant do
      Tenant.all.each do |tenant|
        admin_emails = tenant.reporting_configs.where(email_type: "daily-student-logins").pluck(:email)
        next unless admin_emails.present?

        yesterday = 1.day.ago
        student_uuids = Event.where(tenant_id: tenant.id, created_at: yesterday.beginning_of_day..yesterday.end_of_day, message_type: "online").where("uuid IS NOT NULL AND uuid != ''").pluck(:uuid).uniq.reject { |uuid| uuid.blank? }
        students = Student.where(uuid: student_uuids, tenant_id: tenant.id).map do |student|
          { name: student.name }
        end


        postmark_service = PostmarkService.new(tenant)
        postmark_service.send_daily_student_logins_email({ admin_emails: admin_emails, students: students, tenant: tenant, root_url: root_url(tenant), report_date: yesterday.strftime("%B %-d, %Y") })
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
