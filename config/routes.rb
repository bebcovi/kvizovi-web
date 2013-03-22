Lektire::Application.routes.draw do
  root to: "home#index"

  get "tour", to: "home#index"
  get "contact", to: "home#index"

  ########################
  # Login and registration
  ########################
  controller :sessions do
    get   "login",  to: :new, constraints: ->(request) { request.params[:type].present? }
    post  "login",  to: :create
    match "logout", to: :destroy
  end
  resources :registrations
  resources :authorizations
  resources :password_resets

  ########################
  # Profile
  ########################
  resource :profile
  namespace :profile do
    resource :password
  end

  ########################
  # School
  ########################
  resources :quizzes do
    resources :questions

    member { put "toggle_activation" }
  end

  resources :schools do
    resources :questions
  end
  resources :students

  ########################
  # Student
  ########################
  resource :game

  controller :errors do
    get ":code", to: :show, constraints: {code: /\d+/}
  end
end
