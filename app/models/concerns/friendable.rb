module Friendable
  extend ActiveSupport::Concern

  def friendly_duration_for(minutes)
    return "0" unless minutes.positive?
    hours = minutes / 60
    rest = minutes % 60
    str = "#{pluralize(hours, 'hr') if hours.positive?} #{pluralize(rest, 'min') if rest.positive?}".strip

    if str.include?("hr") && str.include?("min")
      str.gsub(/hrs*/, '\\0 &').strip
    else
      str.strip
    end
  end

  def friendly_full_duration_for(minutes)
    str = friendly_duration_for(minutes).gsub(/hr/, "hour").gsub(/min/, "minute")

    if str.include?("hour") && str.include?("minute")
      str.gsub(/&/, '').gsub(/hours*/, '\\0 and')
    else
      str
    end
  end

  def pluralize(*args)
    ActionController::Base.helpers.pluralize(*args)
  end

  def singularize(*args)
    ActionController::Base.helpers.singularize(*args)
  end
end
