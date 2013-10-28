Lektire::Application.routes.draw do

  constraints host: /herokuapp/ do
    get "(*path)", to: redirect(host: "kvizovi.org")
  end

  constraints subdomain: /www/ do
    get "(*path)", to: redirect(subdomain: false)
  end

  root to: "home#index"

  ########################
  # Authentication
  ########################
  scope constraints: {subdomain: /school|student/} do
    controller :sessions do
      get   "login",  to: :new
      post  "login",  to: :create
      match "logout", to: :destroy, via: [:get, :delete]
    end
    resource :registration
    resource :authorization
    resource :password_reset do
      post "confirm"
      get "create", as: :create
    end
  end

  ########################
  # School
  ########################
  scope constraints: {subdomain: "school"} do
    resources :quizzes do
      resources :questions do
        collection do
          get "order", to: :edit_order
          patch "order", to: :update_order
        end
        member do
          post "download"
          get "download", to: :download_location
        end
      end
    end

    resources :students, only: [:index]
    resources :played_quizzes
  end

  ########################
  # Student
  ########################
  scope constraints: {subdomain: "student"} do
    resource :quiz, only: [], controller: "quiz" do
      get    "choose"
      post   "start"
      get    "play"
      put    "save_answer"
      get    "answer_feedback"
      put    "next_question"
      get    "results"
      get    "interrupt"
      delete "finish"
    end
  end

  ########################
  # School & Student
  ########################
  resource :profile
  resource :password

  resource :email
  resources :surveys

  ########################
  # Static pages
  ########################
  controller :static_pages do
    get "tour"
    get "contact"
    get "blog"
  end

  ########################
  # Admin
  ########################
  namespace :admin do
    root to: redirect("/admin/schools")

    resources :schools
  end
  resources :posts

  ########################
  # Error pages
  ########################
  controller :errors do
    get ":code", to: :show, constraints: {code: /\d+/}
  end

  ########################
  # Legacy routes
  ########################
  get "login",           to: redirect(                      path: "/")
  get "schools/new",     to: redirect(subdomain: "school",  path: "/registration/new")
  get "students/new",    to: redirect(subdomain: "student", path: "/registration/new")
  get "game/new",        to: redirect(subdomain: "student", path: "/quiz/choose")
  get "schools/:id",     to: redirect(subdomain: "school",  path: "/profile")
  get "students/:id",    to: redirect(subdomain: "student", path: "/profile")
  get "students",        to: redirect(subdomain: "school",  path: "/students")
  get "quizzes(*other)", to: redirect(subdomain: "school")

end
