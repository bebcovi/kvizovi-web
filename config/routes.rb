Lektire::Application.routes.draw do
  root to: "home#index"
  get "home/index"

  get "tour", to: "tour#index"
  get "updates", to: "updates#index"
  put "updates/hide", to: "updates#hide", as: "hide_update"
  get "contact", to: "contact#index"

  controller :sessions do
    get   "login",  to: :new
    post  "login",  to: :create
    match "logout", to: :destroy
  end

  resources :authorizations

  resource :game do
    get "feedback"
  end

  resources :questions

  resources :schools do
    resources :questions do
      member {
        get "copy"
        post "download"
      }
    end

    member { put "toggle_question_privacy" }
  end
  resources :students do
    member do
      get "new_password"
      put "change_password"
    end
  end
  resource :password

  resources :quizzes do
    resources :questions do
      member {
        get "copy"
        post "include"
        post "remove"
      }
    end

    member { put "toggle_activation" }
  end

  controller :admin do
    get "admin", to: :index
    get "admin/school/:id", to: :school, as: "admin_school"
  end

  match "404", to: "errors#not_found"
  match "500", to: "errors#internal_server_error"
end
