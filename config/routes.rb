Lektire::Application.routes.draw do

  ########################
  # Authentication
  ########################
  scope constraints: {subdomain: /school|student/} do
    controller :sessions do
      get   "login",  to: :new
      post  "login",  to: :create
      match "logout", to: :destroy
    end
    resource :registration
    resource :authorization
    resource :password_reset
  end

  ########################
  # School
  ########################
  scope constraints: {subdomain: "school"} do
    root to: redirect("/quizzes")

    resources :quizzes do
      resources :questions do
        collection do
          get "order", to: :edit_order
          put "order", to: :update_order
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
    root to: redirect("/quiz/choose")

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

  resources :versions do
    member do
      post "revert"
    end
  end

  ########################
  # Static pages
  ########################
  controller :static_pages do
    get "tour"
    get "contact"
  end

  resource :survey

  ########################
  # Admin
  ########################
  namespace :admin do
    root to: redirect("/admin/schools")

    resources :schools
  end

  root to: "home#index"

  ########################
  # Error pages
  ########################
  controller :errors do
    get ":code", to: :show, constraints: {code: /\d+/}
  end

  ########################
  # Legacy routes
  ########################
  get "login",          to: redirect(                      path: "/")
  get "schools/new",    to: redirect(subdomain: "school",  path: "/registration/new")
  get "students/new",   to: redirect(subdomain: "student", path: "/registration/new")
  get "game/new",       to: redirect(subdomain: "student", path: "/quiz/choose")
  get "schools/:id",    to: redirect(subdomain: "school",  path: "/profile")
  get "students/:id",   to: redirect(subdomain: "student", path: "/profile")
  get "students",       to: redirect(subdomain: "school",  path: "/students")
  get "quizzes/*other", to: redirect { |params, request| {subdomain: "school",  path: "/quizzes/#{params[:other]}"} }

end
