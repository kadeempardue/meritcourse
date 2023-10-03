class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include Detectable
  include Serviceable
  include Authenticatable
  helper_method :setting, :marketing_list, :enrolled_in?, :is_livestream_host?

  helper_method :firebase_service

  def setting
    @tenant.setting || @tenant.create_setting
  end

  def enrolled_in?(course)
    return true if staff_signed_in?
    return false unless student_signed_in?
    current_student.enrollments.find_by(course: course).present?
  end

  def is_livestream_host?(user, lesson)
    lesson.host == user
  end

  def marketing_list
    @marketing_list ||= MarketingList.new
  end

  private

  def pusher_opts(message)
    {
      message: message,
      uuid: pusher_uuid,
      url: request.url,
      ip_address: request.remote_ip,
      time: Time.now,
      browser: {
        name: browser.name,
        full_version: browser.full_version,
        user_agent: browser.ua,
        is_mobile: (browser.mobile? == true),
        is_tablet: (browser.tablet? == true),
      },
      platform: {
        id: browser.platform.id,
        name: browser.platform.name,
        version: browser.platform.version
      },
      device: {
        id: browser.device.id,
        name: browser.device.name,
      }
    }
  end

  def pusher_page
    Pusher.trigger('what-page-am-i-on', 'i-am-here', pusher_opts("#{pusher_name} is on #{request.url}"))
  end

  def pusher_lesson
    Pusher.trigger('what-lesson-am-i-on', 'i-am-learning', pusher_opts("#{pusher_name} is learning #{@course.name} - #{@lesson.name}").merge({
      course: @course.name,
      lesson: @lesson.name,
      is_live: @lesson.is_livestream?,
      time: Time.now
    }))
  end

  def pusher_resource(resource)
    Pusher.trigger('what-resource-am-i-changing', resource.class.to_s, {
      message: "#{pusher_name} is changing #{request.url}",
      uuid: pusher_uuid,
      url: request.url,
      ip_address: request.remote_ip,
      browser: {
        name: browser.name,
        full_version: browser.full_version,
        user_agent: browser.ua,
        is_mobile: (browser.mobile? == true),
        is_tablet: (browser.tablet? == true),
      },
      platform: {
        id: browser.platform.id,
        name: browser.platform.name,
        version: browser.platform.version
      },
      device: {
        id: browser.device.id,
        name: browser.device.name,
      }
    })
  end

  def pusher_name
    @pusher_name ||= student_signed_in? ? current_student.name : "Anonymous"
  end

  def pusher_uuid
    @pusher_uuid = student_signed_in? ? current_student.uuid : nil
  end
end
