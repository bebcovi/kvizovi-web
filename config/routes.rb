Lektire::Application.routes.draw do
  root to: "home#index"
  get "home/index"

  controller :sessions do
    get "student_login", to: :new_student
    post "student_login", to: :create_student
    get "school_login", to: :new_school
    post "school_login", to: :create_school
    match "logout", to: :destroy
  end

  controller :authorize do
    get "authorize", to: :show
    post "authorize", to: :authorize
  end

  resource :game

  resources :schools, :students do
    member { get "delete" }
  end
  resource :password, only: [:edit, :update]

  resources :quizzes do
    resources :questions
  end

  match "404", to: "errors#not_found"
  match "500", to: "errors#internal_server_error"
end
