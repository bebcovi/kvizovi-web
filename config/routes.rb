Lektire::Application.routes.draw do
  root to: "home#index"
  get "home/index"

  controller :tour do
    get "tour" => :index
  end

  controller :contact do
    get "contact" => :index
  end

  controller :sessions do
    get   "login"  => :new
    post  "login"  => :create
    match "logout" => :destroy
  end

  controller :authorize do
    get  "authorize" => :show
    post "authorize" => :authorize
  end

  resource :game do
    get "feedback"
  end

  resources :questions do
    member { get "copy" }
  end

  resources :schools do
    resources :questions

    member { put "notify" }
  end
  resources :students do
    member do
      get "new_password"
      put "change_password"
    end
  end
  resource :password

  resources :notifications

  resources :quizzes do
    resources :questions

    member { put "toggle_activation" }
  end

  match "404" => "errors#not_found"
  match "500" => "errors#internal_server_error"

  controller :admin do
    get "admin" => :index
    get "admin/school/:id" => :school, as: :admin_school
  end
end
