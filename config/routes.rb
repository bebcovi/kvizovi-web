Lektire::Application.routes.draw do
  root to: "home#index"
  get "home/index"

  resources :schools
  resources :students
  resources :books
  resources :quizzes
  resources :questions

  match "404", to: "errors#not_found"
  match "500", to: "errors#internal_server_error"
end
