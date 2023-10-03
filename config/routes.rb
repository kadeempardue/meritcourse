  Rails.application.routes.draw do
  mount Meritadmin::Engine, at: "/admin"

  get "get_token", to: "home#get_token", as: :get_token
  get "z/show", to: "zoom#show", as: :zoom_show
  get "z/ty", to: "zoom#thank_you", as: :zoom_thank_you
  post "z/signature", to: "zoom#signature", as: :signature
  get "p/amionline", to: "pusher#who_is_online", as: :who_is_online
  post "p/webhook", to: "pusher#webhook", as: :pusher_webhook
  post "s/webhook", to: "stripe#webhook", as: :stripe_webhook

  resources :events, only: [:create]
  resources :marketing_lists, only: [:create]

  resources :schedules, only: [:index]

  resources :courses, only: [:show] do
    resources :lessons, only: [:index, :show]
    resources :reviews, only: [:create]
  end

  resources :students, only: [:update]
  get "/users/:uuid/profile", to: "profiles#show"

  resources :enrollments, only: [:create, :update, :destroy]

  get "onboarding", to: "onboarding#index", as: :onboarding

  get "waitlist-subscribed", to: redirect("subscribed")
  get "subscribed", to: "static#subscribed", as: :subscribed

  get "terms", to: "static#terms", as: :terms
  get "privacy-policy", to: "static#privacy", as: :privacy
  get "search", to: "catalog#search", as: :search
  get "courses", to: redirect('/explore')
  get "explore", to: "catalog#explore", as: :explore
  get "explore/:id", to: "catalog#show", as: :explore_subject

  get "register", to: "registrations#new", as: :new_registration
  get "upgrade", to: "registrations#upgrade", as: :upgrade
  post "signup", to: "registrations#create", as: :registration
  post "signin", to: "sessions#create", as: :create_session
  get "login", to: "sessions#new", as: :new_session
  get "logout", to: "sessions#destroy", as: :destroy_session
  get "reset_password", to: "passwords#new", as: :reset_password
  get "change_password", to: "passwords#edit", as: :change_password
  put "update_password", to: "passwords#update", as: :update_password
  post "send_password_link", to: "passwords#send_password_link", as: :send_password_link

  get "profile", to: "profiles#index", as: :profile
  put "profile", to: "profiles#update", as: :profile_update
  get "account", to: "accounts#index", as: :account
  put "account", to: "accounts#update", as: :account_update
  get "billing", to: "accounts#billing", as: :account_billing

  get "blog", to: "articles#index", as: :articles
  get "participant_application", to: "forms#participant_application", as: :participant_application

  resources :forms, only: [:show] do
    resources :form_submissions, only: [:show, :create]
  end
  resources :articles, only: [:show]
  resources :article_comments, only: [:create]

  root "home#index"
end
