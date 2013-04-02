Lektire::Application.routes.draw do
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

    resource :game
  end

  ########################
  # Profile
  ########################
  resource :profile
  resource :password

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
