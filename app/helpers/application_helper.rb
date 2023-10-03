module ApplicationHelper
  def show_header?
    return false if controller_name == 'lessons'
    return false if @show_header == false
    true
  end

  def show_footer?
    return false if controller_name == 'lessons'
    return false if @show_footer == false
    true
  end

  def preview_mode?
    params[:admin_preview] == "true" && current_admin_user.present?
  end

  def avatar_helper(student)
    student&.profile_image || setting.logo_icon
  end

  def logout_url
    new_session_url
  end

  def enrolled?(user, course)
    return false unless user && course

    enrollment = user.enrollments.where(course: course).first
    return false unless enrollment.present?

    enrollment.active?
  end

  def course_included_in_program?(course, programs)
    true
    # TODO
  end

  def friendly_date(date)
    return unless date.present?
    date.strftime("%B %-d, %Y")
  end

  def friendly_time(date, timezone = false)
    return unless date.present?

    date.strftime("%l:%M %p #{'%z' if timezone}")
  end

  def active_class(ctrl_name)
    if ctrl_name.is_a?(Array)
      "uk-background-muted active-submenu" if ctrl_name.any? { |ctrl| ctrl.to_s == controller_name }
    else
      "uk-background-muted" if ctrl_name.to_s == controller_name
    end
  end

  def fixed_nav_active_class(ctrl_name, actn_name)
    if ctrl_name.is_a?(Array)
      "uk-active" if ctrl_name.any? { |ctrl| ctrl.to_s == controller_name } && actn_name.to_s == action_name
    else
      "uk-active" if ctrl_name.to_s == controller_name && actn_name.to_s == action_name
    end
  end

  def default_image_options(opts = {})
    {
      transformation: [
        { width: 400, height: 300, gravity: "face", radius: "max", crop: "crop" },
        { width: 200, crop: "scale" }
      ]
    }.merge(opts.merge(quality: "auto:best"))
  end

  def total_count(resource)
    current_count = resource.entries.count
    total_count = resource.total_count
    "Showing <span class='current_count'>#{current_count}</span> out of <span class='total_count'>#{total_count}</span>".html_safe
  end

  def star_rating_group_for_all_courses(threshold)
    filtered_reviews = ::Course.group_all_reviews_by_threshold(courses, threshold)
    {
      html: star_rating(threshold, avg: false),
      count: filtered_reviews.count,
      percentage: ::Review.percentage_of(filtered_reviews, reviews),
      review_count: ::Review.percentage_of(filtered_reviews, reviews)
    }
  end

  def star_rating_group_for_course(course, threshold)
    filtered_reviews = course.group_reviews_by_threshold(threshold)
    {
      html: star_rating(threshold, avg: false),
      count: filtered_reviews.count,
      percentage: ::Review.percentage_of(filtered_reviews, course.reviews),
      review_count: ::Review.percentage_of(filtered_reviews, course.reviews)
    }
  end

  def star_rating(rating, options = {})
    rating = rating.to_f
    html = "<div class='star-rating'>"
    html += "<span class='avg'>#{rating}</span>" unless options[:avg] == false
    modulo = rating.modulo(1).round(2)
    modulo_flag = false

    5.times.each do |x|
      extra_class = 'empty'
      if rating.to_i > x
        extra_class = ''
      elsif !modulo_flag
        extra_class = 'quarter'       if modulo >  0.0
        extra_class = 'half'          if modulo >= 0.5
        extra_class = 'three_quarter' if modulo >= 0.75
        modulo_flag = true
      else
        extra_class = 'empty'
      end
      html += "<span class='star #{extra_class}'></span>"
    end

    html += '</div>'
    html.html_safe
  end

  def friendly_icon_for_lesson_type(lesson_type)
    case lesson_type
    when "Lecture"
      "<i class='icon-feather-video'></i> Lecture"
    when "Project"
      "<i class='icon-material-outline-assessment'></i> Project"
    when "Assessment"
      "<i class='icon-material-outline-assessment'></i> Assessment"
    when "Interactive Activity"
      "<i class='icon-material-outline-code'></i> Interactive Activity"
    end.html_safe
  end

  def friendly_duration_for(minutes)
    minutes = minutes.to_i
    return 0 unless minutes.positive?
    hours = minutes / 60
    rest = minutes % 60
    "#{pluralize(hours, 'hr') if hours.positive?} #{pluralize(rest, 'min') if rest.positive?}"
  end

  private

  def to_query(hash)
    hash.map { |k, v| "#{k}=#{URI.escape(v)}" unless v.nil? }.reject(&:nil?).join('&')
  end
end
