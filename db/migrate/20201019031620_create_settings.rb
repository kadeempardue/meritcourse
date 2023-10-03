class CreateSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :settings do |t|
      t.string :primary_color
      t.string :secondary_color
      t.string :tertiary_color
      t.boolean :registration_enabled, null: false, default: true
      t.boolean :is_membership_portal, null: false, default: true
      t.boolean :has_newsletter, null: false, default: true
      t.boolean :has_blog, null: false, default: true
      t.boolean :has_testimonials, null: false, default: true
      t.boolean :has_programs, null: false, default: true
      t.string :blog_name, default: "Blog"
      t.string :programs_name, default: "Programs"
      t.string :favicon_url, default: "https://via.placeholder.com/50x50"
      t.string :logo_url, default: "https://via.placeholder.com/350x150"
      t.string :logo_icon, default: "https://via.placeholder.com/150x150"
      t.mediumtext :custom_head_tags
      t.mediumtext :custom_before_body_tags
      t.mediumtext :custom_after_body_tags
      t.longtext :custom_css
      t.string :navigation_explore_path_text, default: "Explore"
      t.string :navigation_blog_path_text, default: "Blog"
      t.string :registration_button_text, default: "GET STARTED"
      t.string :registration_button_url, default: "/register"
      t.string :homepage_hero_background_image, default: "https://via.placeholder.com/1200x500.png"
      t.string :homepage_hero_background_text, default: "Hero Text Here"
      t.string :homepage_hero_background_subtext, default: "Hero SubText Here"
      t.string :homepage_hero_background_button_text, default: "Button Text Here"
      t.string :homepage_hero_background_button_url, default: "https://google.com"
      t.string :homepage_banner_left_side_headline, default: "Headline here."
      t.string :homepage_banner_left_side_text, default: "Text here."
      t.string :homepage_banner_left_side_button_text, default: "Button Text Here"
      t.string :homepage_banner_left_side_button_url, default: "https://google.com"
      t.string :homepage_banner_right_side_image, default: "/assets/default/1200x500.png"
      t.string :homepage_banner_right_side_overlay_gradient_front_color, default: "#4866ff"
      t.string :homepage_banner_right_side_overlay_gradient_back_color, default: "#6fe5f3"
      t.longtext :homepage_callout_banner
      t.string :homepage_courses_headline, default: "Browse Our Courses"
      t.string :homepage_subjects_headline, default: "Explore Subjects"
      t.string :homepage_programs_headline, default: "Become Professionally Certified"
      t.string :sign_up_key, default: SecureRandom.hex(24), null: false
      t.longtext :terms_of_service
      t.longtext :privacy_policy
      t.string :social_media_youtube_channel_id
      t.string :social_media_facebook_page_id
      t.string :social_media_twitter_handle
      t.integer :tenant_id, index: true
      t.timestamps
    end
  end
end
