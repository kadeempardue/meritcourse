require 'sidekiq/web'

Meritadmin::Engine.routes.draw do
  # mount Sidekiq::Web => '/sidekiq'

  devise_for :admin_users, controllers: {
    sessions: 'meritadmin/sessions',
    registrations: 'meritadmin/registrations',
    passwords: 'meritadmin/passwords',
    unlocks: 'meritadmin/unlocks',
    confirmations: 'meritadmin/confirmations',
  }, class_name: 'Meritadmin::AdminUser', module: 'meritadmin', path: 'auth', path_names: { sign_in: 'login', sign_out: 'logout' }
  # omniauth_callbacks: 'meritadmin/omniauth_callbacks',

  resources :schedules
  resources :students
  resources :staffs
  resources :subjects
  resources :programs
  resources :badges
  resources :reports, except: [:edit, :update]

  resources :courses do
    resources :lessons do
      post "send_badge", to: "courses#send_badge", as: :send_badge
      post "deny_badge", to: "courses#deny_badge", as: :deny_badge
    end
    resources :reviews
    resources :enrollments
    get "analytics", to: "courses#analytics", as: :analytics
    get "analytics/:lesson_id", to: "courses#lesson_analytics", as: :lesson_analytics
  end

  resources :articles
  resources :plans
  resources :faqs
  resources :forms
  resources :form_submissions, only: [:index, :show]

  get "t", to: "uploader#token"
  post "upload_file", to: "uploader#file_upload"
  get "media_library", to: "media_library#index", as: :media_library
  post "upload_media", to: "media_library#create", as: :upload_media

  scope :memberships, path: :memberships, as: :memberships do
    get "subscriptions", to: "memberships#subscriptions"
    get "payouts", to: "memberships#payouts"
    get "account", to: "memberships#account"
  end

  scope :integrations, path: :integrations, as: :integrations do
    get "/", to: "integrations#index"
    get "stripe", to: "integrations#stripe"
    get "stripe_connected", to: "stripe#connected"
    get "postmark", to: "integrations#postmark"
  end

  resources :tags

  get "help",               to: "help#index",       as: :help
  post "send_reset_password_instructions_for_admin", to: "passwords#send_reset_password_instructions_for_admin", as: :send_reset_password_instructions_for_admin

  # Admin To Student or Staff
  post "send_reset_password_instructions_for_student_or_staff", to: "passwords#send_reset_password_instructions_for_student_or_staff", as: :send_reset_password_instructions_for_student_or_staff

  root "dashboard#index", as: :admin_root
end
