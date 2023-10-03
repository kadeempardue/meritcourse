class AddSettingsToTsnAndBta < ActiveRecord::Migration[5.1]
  def change
    ActsAsTenant.without_tenant do
      tenant1 = Tenant.find_by(key: "tsn")
      tenant2 = Tenant.find_by(key: "bta")
      # TSN
      Setting.create(
        primary_color: "#233A7A",
        secondary_color: "#356184",
        tertiary_color: "#3980FF",
        registration_enabled: false,
        is_membership_portal: false,
        has_newsletter: false,
        has_blog: false,
        has_testimonials: true,
        has_programs: true,
        blog_name: "TSN Academy Blog",
        # programs_name: "Programs Paths",
        favicon_url: "/assets/tsn/favicon.png",
        logo_url: "/assets/tsn/logo-horizontal.png",
        logo_icon: "/assets/tsn/logo-icon2.png",
        # custom_head_tags: "",
        # custom_before_body_tags: "",
        # custom_after_body_tags: "",
        # custom_css: ,
        navigation_explore_path_text: "Certification Paths",
        # navigation_blog_path_text: ,
        registration_button_text: "Sign Up",
        registration_button_url: "/register",
        homepage_hero_background_image: "/assets/tsn/hero.jpg",
        homepage_hero_background_text: "EQUIPPING THE COMMUNITY<br>WITH ACCESS TO ADVANCED CAREER PATHS",
        homepage_hero_background_subtext: "Through Modern Technology, Online Training and Professional Certification Programs",
        homepage_hero_background_button_text: "Welcome to TSN Academy",
        homepage_hero_background_button_url: "/login",
        # homepage_banner_left_side_headline: ,
        # homepage_banner_left_side_text: ,
        # homepage_banner_left_side_button_text: ,
        # homepage_banner_left_side_button_url: ,
        # homepage_banner_right_side_image: ,
        # homepage_banner_right_side_overlay_gradient_front_color: ,
        # homepage_banner_right_side_overlay_gradient_back_color: ,
        homepage_callout_banner: '<div class="mb-8 uk-animation-fade uk-height-max-large uk-background-cover uk-light uk-padding-large uk-background-center-center">
                    <div class="container uk-animation-slide-top-small">
                      <div class="uk-child-width-1-2@s uk-grid" uk-grid="">
                        <div class="p-0 uk-first-column">
                          <div class="uk-light uk-background-primary uk-padding uk-width-4-5" style="background-color: #0ede66;">
                              <h3>WHY CERT PREP?</h3>
                              <div>
                                <p class="text-white">Certification preparation is one of the best ways to get started in a STEM-based career.<br><br>Our platform offers a wide variety of professional certifications that are evaluated by highly trained professionals. Explore your new career path today</p>
                                <a href="#" class="button grey large mt-2">
                                  FIND A CERTIFICATION NOW
                                </a>
                              </div>
                          </div>
                        </div>
                        <div class="overlay-gradient">
                          <div class="overlay-nudge">
                            <img data-src="https://albumizr.com/ia/4de5b4547c5278d07f5efb87b14d06f8.jpg" uk-img="" src="https://albumizr.com/ia/4de5b4547c5278d07f5efb87b14d06f8.jpg">
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>',
        homepage_courses_headline: "Featured Course",
        # homepage_subjects_headline: ,
        # homepage_programs_headline: ,
        sign_up_key: "tsn20201!4$2@",
        # terms_of_service: ,
        # privacy_policy: ,
        # social_media_youtube_channel_id: ,
        # social_media_facebook_page_id: ,
        social_media_twitter_handle: "TSNetwork_",
        tenant: tenant1,
      )

      # BTA
      Setting.create(
        primary_color: "#3a3c38",
        secondary_color: "#8c3527",
        tertiary_color: "#ffb500",
        registration_enabled: true,
        is_membership_portal: true,
        has_newsletter: true,
        has_blog: true,
        has_testimonials: true,
        has_programs: true,
        blog_name: "Black Tech Academy Blog",
        # programs_name: "Programs Paths",
        favicon_url: "/assets/bta/favicon.png",
        logo_url: "/assets/bta/logo-horizontal.png",
        logo_icon: "/assets/bta/logo-icon.png",
        # custom_head_tags: "",
        # custom_before_body_tags: "",
        # custom_after_body_tags: "",
        custom_css: ".home-hero {background-position: bottom right;}",
        # navigation_explore_path_text: "Explore Paths",
        # navigation_blog_path_text: ,
        registration_button_text: "Sign Up",
        registration_button_url: "/register",
        homepage_hero_background_image: "/assets/bta/hero.jpg",
        homepage_hero_background_text: "LEARN TECH AT YOUR PACE",
        homepage_hero_background_subtext: "Study Lessons and Explore Topics Through Shared Experience.",
        homepage_hero_background_button_text: "Sign Up Now",
        homepage_hero_background_button_url: "/register",
        # homepage_banner_left_side_headline: ,
        # homepage_banner_left_side_text: ,
        # homepage_banner_left_side_button_text: ,
        # homepage_banner_left_side_button_url: ,
        # homepage_banner_right_side_image: ,
        # homepage_banner_right_side_overlay_gradient_front_color: ,
        # homepage_banner_right_side_overlay_gradient_back_color: ,
        homepage_callout_banner: '<div class="mb-4 uk-animation-fade uk-height-max-large uk-background-cover uk-light uk-padding-large uk-background-center-center border-dashed-gold" data-src="/assets/bta/banner-hat.jpg" uk-img>
                  <div class="container uk-animation-slide-top-small">
                    <div class="uk-child-width-1-3@s">
                      <div class="p-0">
                        <div class="uk-light uk-background-tertiary uk-padding">
                            <h3 class="text-gold">Stay On Track</h3>
                            <div>
                              <p class="text-white">Our eLearning platform is designed to help next wave of black tech professionals.</p><p class="text-white">We put our community first.</p>
                            </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>',
        homepage_courses_headline: "Featured Course",
        # homepage_subjects_headline: ,
        # homepage_programs_headline: ,
        sign_up_key: "F@t9i2#@8239!a.as94$83!",
        # terms_of_service: ,
        # privacy_policy: ,
        social_media_youtube_channel_id: "UC8QxlHre78mVD2GpBqnN81A",
        social_media_facebook_page_id: "blacktechacademy",
        social_media_twitter_handle: "blktechacademy",
        tenant: tenant2,
      )
    end
  end
end
