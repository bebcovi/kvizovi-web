Lektire::Application.routes.draw do
  root to: "home#index"
  get "home/index"

  controller :tour do
    get "tour" => :index
  end

  controller :sessions do
    get   "student_login"  => :new_student
    post  "student_login"  => :create_student
    get   "school_login"   => :new_school
    post  "school_login"   => :create_school
    match "logout"         => :destroy
  end

  controller :authorize do
    get  "authorize" => :show
    post "authorize" => :authorize
  end

  resource :game do
    get "feedback"
  end

  resources :schools, :students
  resource :password, only: [:edit, :update]

  resources :quizzes do
    resources :questions
  end

  match "404" => "errors#not_found"
  match "500" => "errors#internal_server_error"
end
