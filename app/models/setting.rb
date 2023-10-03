class Setting < ApplicationRecord
  acts_as_tenant(:tenant)

  def lesson_layout?(val)
    layout_for_lessons == val
  end

  def lesson_view_with_left_sidebar?
    lesson_layout?("with_left_sidebar")
  end
end
