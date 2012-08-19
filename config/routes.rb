Lektire::Application.routes.draw do
  root to: "sessions#new"

  controller :sessions do
    get "login", to: :new
    post "login", to: :create
    delete "logout", to: :destroy
  end

  resource :game do
    get "play/:question", to: :play, as: :play
    put "play/:question", to: :update
  end

  resources :schools
  resources :students
  resources :eras
  resources :books
  resources :quizzes do
    resources :questions
  end

  match "404", to: "errors#not_found"
  match "500", to: "errors#internal_server_error"
end
