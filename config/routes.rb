Lektire::Application.routes.draw do
  ########################
  # Admin
  ########################

  controller :admin do
    get "admin", to: :index
    get "admin/:action"
    get "admin/school/:id", to: :school, as: "admin_school"
  end

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
      resources :questions

      member do
        put "toggle_activation"
      end
    end
  end

  ########################
  # Student
  ########################
  scope constraints: {subdomain: "student"} do
    root to: redirect("/game/new")

    resource :game do
      get "feedback"
      get "next_question"
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
  get "login",        to: redirect(                      path: "/")
  get "schools/new",  to: redirect(subdomain: "school",  path: "/registration/new")
  get "students/new", to: redirect(subdomain: "student", path: "/registration/new")
end
