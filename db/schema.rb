# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2021_08_25_154159) do
  create_table "admin_users", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.integer "tenant_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
    t.index ["tenant_id"], name: "index_admin_users_on_tenant_id"
  end

  create_table "agendas", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.integer "minute_ticket", null: false
    t.text "name", null: false
    t.bigint "schedule_id", null: false
    t.integer "tenant_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["schedule_id"], name: "index_agendas_on_schedule_id"
    t.index ["tenant_id"], name: "index_agendas_on_tenant_id"
  end

  create_table "article_comments", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "article_id", null: false
    t.bigint "student_id", null: false
    t.bigint "comment_id"
    t.text "comment", null: false
    t.integer "tenant_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["article_id"], name: "index_article_comments_on_article_id"
    t.index ["comment_id"], name: "index_article_comments_on_comment_id"
    t.index ["student_id"], name: "index_article_comments_on_student_id"
    t.index ["tenant_id"], name: "index_article_comments_on_tenant_id"
  end

  create_table "articles", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "title", null: false
    t.string "category", null: false
    t.string "featured_image"
    t.text "body", size: :long, null: false
    t.string "post_status", default: "Draft"
    t.integer "tenant_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "slug"
    t.index ["body"], name: "articles_body_fts", type: :fulltext
    t.index ["category"], name: "articles_category_fts", type: :fulltext
    t.index ["slug"], name: "index_articles_on_slug", unique: true
    t.index ["tenant_id"], name: "index_articles_on_tenant_id"
    t.index ["title"], name: "articles_title_fts", type: :fulltext
  end

  create_table "awarded_badges", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "student_id", null: false
    t.bigint "badge_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "tenant_id"
    t.bigint "lesson_id"
    t.datetime "display_date", precision: nil
    t.index ["badge_id"], name: "index_awarded_badges_on_badge_id"
    t.index ["lesson_id"], name: "index_awarded_badges_on_lesson_id"
    t.index ["student_id"], name: "index_awarded_badges_on_student_id"
    t.index ["tenant_id"], name: "index_awarded_badges_on_tenant_id"
  end

  create_table "aws_files", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.text "url", null: false
    t.text "key", null: false
    t.integer "tenant_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["tenant_id"], name: "index_aws_files_on_tenant_id"
  end

  create_table "badges", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "name", null: false
    t.string "course_name"
    t.string "lesson_name"
    t.string "lesson_level"
    t.string "issued_by"
    t.text "description"
    t.text "skills"
    t.text "earning_criteria", null: false
    t.text "image_url", null: false
    t.integer "tenant_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "badges_name_fts", type: :fulltext
    t.index ["tenant_id"], name: "index_badges_on_tenant_id"
  end

  create_table "cloudinary_configs", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.text "folder_name", null: false
    t.integer "tenant_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["tenant_id"], name: "index_cloudinary_configs_on_tenant_id"
  end

  create_table "courses", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "name", null: false
    t.string "featured_preview_video_url"
    t.string "featured_preview_image_url"
    t.boolean "is_preview", default: true, null: false
    t.string "level", null: false
    t.text "description", size: :medium
    t.text "excerpt", size: :medium
    t.text "objectives", size: :medium
    t.text "requirements", size: :medium
    t.bigint "subject_id"
    t.integer "tenant_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "slug"
    t.string "plan_access"
    t.string "video_caption"
    t.boolean "archived", default: false, null: false
    t.index ["name"], name: "courses_name_fts", type: :fulltext
    t.index ["objectives"], name: "courses_objectives_fts", type: :fulltext
    t.index ["slug"], name: "index_courses_on_slug", unique: true
    t.index ["subject_id"], name: "index_courses_on_subject_id"
    t.index ["tenant_id"], name: "index_courses_on_tenant_id"
  end

  create_table "enrollments", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.datetime "enrollment_date", precision: nil, null: false
    t.string "enrollment_status", null: false
    t.bigint "course_id"
    t.bigint "student_id"
    t.integer "tenant_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.json "analytics"
    t.index ["course_id"], name: "index_enrollments_on_course_id"
    t.index ["student_id"], name: "index_enrollments_on_student_id"
    t.index ["tenant_id"], name: "index_enrollments_on_tenant_id"
  end

  create_table "events", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.json "message", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "tenant_id"
    t.string "message_type", null: false
    t.string "uuid"
  end

  create_table "faqs", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.integer "tenant_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "faqs_name_fts", type: :fulltext
    t.index ["tenant_id"], name: "index_faqs_on_tenant_id"
  end

  create_table "form_submissions", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.text "data", size: :long, null: false
    t.text "submission", size: :long
    t.bigint "form_id", null: false
    t.integer "tenant_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.index ["form_id"], name: "index_form_submissions_on_form_id"
    t.index ["tenant_id"], name: "index_form_submissions_on_tenant_id"
  end

  create_table "forms", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "slug", null: false
    t.string "name", null: false
    t.text "data", size: :long, null: false
    t.integer "tenant_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "redirect_url"
    t.boolean "register_account", default: false, null: false
    t.string "password_digest"
    t.index ["tenant_id"], name: "index_forms_on_tenant_id"
  end

  create_table "friendly_id_slugs", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, length: { slug: 70, scope: 70 }
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", length: { slug: 140 }
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "lessons", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "name"
    t.string "module_name"
    t.integer "duration"
    t.boolean "is_preview", default: true, null: false
    t.string "lesson_type"
    t.string "video_url"
    t.string "image_url"
    t.text "handouts", size: :medium
    t.bigint "course_id"
    t.integer "tenant_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "is_full_width", default: false, null: false
    t.boolean "is_livestream", default: false, null: false
    t.string "permanent_sid"
    t.text "pdf_url"
    t.integer "host_id"
    t.boolean "is_scheduled", default: false, null: false
    t.text "excerpt", size: :medium
    t.text "badges"
    t.boolean "is_locked", default: false
    t.boolean "is_archived", default: false
    t.index ["course_id"], name: "index_lessons_on_course_id"
    t.index ["tenant_id"], name: "index_lessons_on_tenant_id"
  end

  create_table "marketing_lists", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "first_name"
    t.string "email", null: false
    t.string "list_name", null: false
    t.integer "tenant_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["tenant_id"], name: "index_marketing_lists_on_tenant_id"
  end

  create_table "plans", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "name", null: false
    t.integer "amount", null: false
    t.string "currency", null: false
    t.string "interval", null: false
    t.integer "interval_count"
    t.bigint "stripe_product_id", null: false
    t.bigint "stripe_price_id", null: false
    t.bigint "stripe_connect_account_id", null: false
    t.integer "tenant_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "excerpt"
    t.text "description"
    t.string "feature_1"
    t.string "feature_2"
    t.string "feature_3"
    t.string "feature_4"
    t.string "feature_5"
    t.text "feature_1_help_text"
    t.text "feature_2_help_text"
    t.text "feature_3_help_text"
    t.text "feature_4_help_text"
    t.text "feature_5_help_text"
    t.string "color"
    t.boolean "recommended", default: false, null: false
    t.integer "order"
    t.index ["name"], name: "plans_name_fts", type: :fulltext
    t.index ["stripe_connect_account_id"], name: "index_plans_on_stripe_connect_account_id"
    t.index ["stripe_price_id"], name: "index_plans_on_stripe_price_id"
    t.index ["stripe_product_id"], name: "index_plans_on_stripe_product_id"
    t.index ["tenant_id"], name: "index_plans_on_tenant_id"
  end

  create_table "postmark_settings", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "postmark_confirmed"
    t.string "postmark_domain_name"
    t.integer "postmark_domain_id"
    t.text "postmark_dkim_pending_host"
    t.text "postmark_dkim_pending_text_value"
    t.string "postmark_dkim_update_status"
    t.string "postmark_return_path_domain", default: "pm-bounces"
    t.text "postmark_return_path_domain_cname_value"
    t.boolean "postmark_return_path_domain_verified"
    t.string "postmark_from_email"
    t.string "postmark_from_name"
    t.integer "postmark_sender_id"
    t.integer "tenant_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["tenant_id"], name: "index_postmark_settings_on_tenant_id"
  end

  create_table "programs", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.text "course_ids"
    t.text "concepts"
    t.text "outcomes"
    t.integer "tenant_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "slug"
    t.text "featured_image_url"
    t.index ["concepts"], name: "programs_concepts_fts", type: :fulltext
    t.index ["description"], name: "programs_description_fts", type: :fulltext
    t.index ["name"], name: "programs_name_fts", type: :fulltext
    t.index ["slug"], name: "index_programs_on_slug", unique: true
    t.index ["tenant_id"], name: "index_programs_on_tenant_id"
  end

  create_table "reporting_configs", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "email", null: false
    t.string "email_type", null: false
    t.integer "tenant_id"
    t.index ["tenant_id"], name: "index_reporting_configs_on_tenant_id"
  end

  create_table "reports", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "report_type", null: false
    t.integer "tenant_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["tenant_id"], name: "index_reports_on_tenant_id"
  end

  create_table "reviews", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.text "comment", null: false
    t.float "rating", null: false
    t.bigint "course_id"
    t.bigint "student_id"
    t.integer "tenant_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["course_id"], name: "index_reviews_on_course_id"
    t.index ["student_id"], name: "index_reviews_on_student_id"
    t.index ["tenant_id"], name: "index_reviews_on_tenant_id"
  end

  create_table "schedules", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.datetime "start_datetime", precision: nil, null: false
    t.datetime "end_datetime", precision: nil, null: false
    t.integer "join_window", default: 15, null: false
    t.bigint "lesson_id", null: false
    t.integer "tenant_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["lesson_id"], name: "index_schedules_on_lesson_id"
    t.index ["tenant_id"], name: "index_schedules_on_tenant_id"
  end

  create_table "sessions", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "settings", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "primary_color"
    t.string "secondary_color"
    t.string "tertiary_color"
    t.boolean "registration_enabled", default: true, null: false
    t.boolean "is_membership_portal", default: true, null: false
    t.boolean "has_newsletter", default: true, null: false
    t.boolean "has_blog", default: true, null: false
    t.boolean "has_testimonials", default: true, null: false
    t.boolean "has_programs", default: true, null: false
    t.string "blog_name", default: "Blog"
    t.string "programs_name", default: "Programs"
    t.string "favicon_url", default: "https://via.placeholder.com/50x50"
    t.string "logo_url", default: "https://via.placeholder.com/350x150"
    t.string "logo_icon", default: "https://via.placeholder.com/150x150"
    t.text "custom_head_tags", size: :medium
    t.text "custom_before_body_tags", size: :medium
    t.text "custom_after_body_tags", size: :medium
    t.text "custom_css", size: :long
    t.string "navigation_explore_path_text", default: "Explore"
    t.string "navigation_blog_path_text", default: "Blog"
    t.string "registration_button_text", default: "GET STARTED"
    t.string "registration_button_url", default: "/register"
    t.string "homepage_hero_background_image", default: "https://via.placeholder.com/1200x500.png"
    t.string "homepage_hero_background_text", default: "Hero Text Here"
    t.string "homepage_hero_background_subtext", default: "Hero SubText Here"
    t.string "homepage_hero_background_button_text", default: "Button Text Here"
    t.string "homepage_hero_background_button_url", default: "https://google.com"
    t.string "homepage_banner_left_side_headline", default: "Headline here."
    t.string "homepage_banner_left_side_text", default: "Text here."
    t.string "homepage_banner_left_side_button_text", default: "Button Text Here"
    t.string "homepage_banner_left_side_button_url", default: "https://google.com"
    t.string "homepage_banner_right_side_image", default: "/assets/default/1200x500.png"
    t.string "homepage_banner_right_side_overlay_gradient_front_color", default: "#4866ff"
    t.string "homepage_banner_right_side_overlay_gradient_back_color", default: "#6fe5f3"
    t.text "homepage_callout_banner", size: :long
    t.string "homepage_courses_headline", default: "Browse Our Courses"
    t.string "homepage_subjects_headline", default: "Explore Subjects"
    t.string "homepage_programs_headline", default: "Become Professionally Certified"
    t.string "sign_up_key", default: "d0c78aacdb1ccdb291996a90db6b5d0f2150948dfc1f54c5", null: false
    t.text "terms_of_service", size: :long
    t.text "privacy_policy", size: :long
    t.string "social_media_youtube_channel_id"
    t.string "social_media_facebook_page_id"
    t.string "social_media_twitter_handle"
    t.integer "tenant_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "layout_for_lessons", default: "fullpage", null: false
    t.string "quadrant_color"
    t.string "quaternary_color"
    t.string "quinary_color"
    t.string "senary_color"
    t.string "septenary_color"
    t.string "octonary_color"
    t.string "nonary_color"
    t.string "denary_color"
    t.string "undenary_color"
    t.string "duodenary_color"
    t.string "ternidenary_color"
    t.string "social_media_instagram_handle"
    t.index ["tenant_id"], name: "index_settings_on_tenant_id"
  end

  create_table "staffs", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "profile_image"
    t.string "title"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "reset_password_token"
    t.datetime "reset_password_token_date", precision: nil
    t.string "uuid"
    t.integer "tenant_id"
    t.text "firebase_refresh_token"
    t.text "firebase_id_token"
    t.datetime "firebase_issued_at", precision: nil
    t.datetime "firebase_expiration", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["tenant_id"], name: "index_staffs_on_tenant_id"
  end

  create_table "stripe_connect_accounts", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "token_type"
    t.string "stripe_publishable_key"
    t.string "scope"
    t.boolean "livemode"
    t.string "stripe_user_id"
    t.string "refresh_token"
    t.string "access_token"
    t.integer "tenant_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["stripe_user_id"], name: "index_stripe_connect_accounts_on_stripe_user_id", unique: true
    t.index ["tenant_id"], name: "index_stripe_connect_accounts_on_tenant_id"
  end

  create_table "stripe_prices", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "stripe_price_id", null: false
    t.boolean "active", null: false
    t.string "currency", null: false
    t.text "recurring", null: false
    t.string "price_type", null: false
    t.integer "unit_amount", null: false
    t.string "billing_scheme", null: false
    t.integer "created_unix", null: false
    t.boolean "livemode", default: false, null: false
    t.bigint "stripe_connect_account_id", null: false
    t.integer "tenant_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "stripe_product_id"
    t.index ["stripe_connect_account_id"], name: "index_stripe_prices_on_stripe_connect_account_id"
    t.index ["tenant_id"], name: "index_stripe_prices_on_tenant_id"
  end

  create_table "stripe_products", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "stripe_product_id", null: false
    t.boolean "active", null: false
    t.text "description"
    t.string "name", null: false
    t.integer "created_unix", null: false
    t.integer "updated_unix", null: false
    t.boolean "livemode", default: false, null: false
    t.text "statement_descriptor"
    t.string "product_type", default: "service", null: false
    t.bigint "stripe_connect_account_id", null: false
    t.integer "tenant_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["stripe_connect_account_id"], name: "index_stripe_products_on_stripe_connect_account_id"
    t.index ["tenant_id"], name: "index_stripe_products_on_tenant_id"
  end

  create_table "students", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "profile_image"
    t.string "title"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "membership_id"
    t.string "membership_subscription_id"
    t.string "membership_interval"
    t.string "membership_status"
    t.boolean "tos_agreement", default: false, null: false
    t.string "reset_password_token"
    t.datetime "reset_password_token_date", precision: nil
    t.string "uuid"
    t.integer "tenant_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.datetime "tos_acceptance_date", precision: nil
    t.text "firebase_refresh_token"
    t.text "firebase_id_token"
    t.datetime "firebase_issued_at", precision: nil
    t.datetime "firebase_expiration", precision: nil
    t.string "phone_number"
    t.integer "current_plan_id"
    t.string "gender"
    t.string "ethncity"
    t.string "age_range"
    t.string "income"
    t.boolean "onboarding_complete", default: false, null: false
    t.string "username"
    t.index ["email"], name: "students_email_fts", type: :fulltext
    t.index ["first_name"], name: "students_first_name_fts", type: :fulltext
    t.index ["last_name"], name: "students_last_name_fts", type: :fulltext
    t.index ["tenant_id"], name: "index_students_on_tenant_id"
  end

  create_table "subjects", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "name"
    t.string "icon_url"
    t.boolean "is_preview", default: false
    t.string "description"
    t.string "course_count"
    t.integer "tenant_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "slug"
    t.index ["description"], name: "subjects_description_fts", type: :fulltext
    t.index ["name"], name: "subjects_name_fts", type: :fulltext
    t.index ["slug"], name: "index_subjects_on_slug", unique: true
    t.index ["tenant_id"], name: "index_subjects_on_tenant_id"
  end

  create_table "tenants", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "name", null: false
    t.string "subdomain"
    t.string "domain"
    t.string "key", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "firebase_tenant_id"
  end

  create_table "twilio_group_rooms", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "unique_name"
    t.text "account_sid"
    t.text "sid"
    t.string "status"
    t.boolean "enable_turn", default: true, null: false
    t.datetime "date_created", precision: nil
    t.datetime "date_updated", precision: nil
    t.text "status_callback"
    t.string "status_callback_method"
    t.datetime "end_time", precision: nil
    t.text "duration"
    t.boolean "record_participants_on_connect", default: true, null: false
    t.text "video_codecs", null: false
    t.text "links"
    t.text "url", null: false
    t.bigint "lesson_id"
    t.integer "tenant_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["lesson_id"], name: "index_twilio_group_rooms_on_lesson_id"
    t.index ["tenant_id"], name: "index_twilio_group_rooms_on_tenant_id"
  end

  create_table "unawarded_badges", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "student_id", null: false
    t.bigint "badge_id", null: false
    t.bigint "lesson_id"
    t.bigint "tenant_id"
    t.datetime "display_date", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["badge_id"], name: "index_unawarded_badges_on_badge_id"
    t.index ["lesson_id"], name: "index_unawarded_badges_on_lesson_id"
    t.index ["student_id"], name: "index_unawarded_badges_on_student_id"
    t.index ["tenant_id"], name: "index_unawarded_badges_on_tenant_id"
  end

end
