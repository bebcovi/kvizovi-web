Lektire::Application.routes.draw do
  ########################
  # School
  ########################
  scope constraints: {subdomain: "school"}, module: :school do
    root to: redirect("/quizzes")

    # Login and registration
    controller :sessions do
      get   "login",  to: :new
      post  "login",  to: :create
      match "logout", to: :destroy
    end
    resource :registration
    resource :authorization
    resource :password_reset

    # Profile
    resource :profile
    resource :password

    # Making quizzes
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
  scope constraints: {subdomain: "student"}, module: :student do
    root to: redirect("/game/new")

    # Login and registration
    controller :sessions do
      get   "login",  to: :new
      post  "login",  to: :create
      match "logout", to: :destroy
    end
    resource :registration

    # Profile
    resource :profile
    resource :password

    # Playing quizzes
    resource :game
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
end
