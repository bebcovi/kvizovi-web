Kvizovi::Application.routes.draw do

  constraints subdomain: "www" do
    get "(*path)", to: redirect(subdomain: false)
  end

  root to: "home#index"

  devise_for :schools
  devise_for :students

  namespace :account do
    resources :quizzes do
      resources :questions do
        collection do
          get "order", to: :edit_order
          patch "order", to: :update_order
        end
      end
    end

    resources :students
    resource  :profile
  end

  resources :played_quizzes

  ########################
  # Student
  ########################
  resource :quiz, only: [], controller: "quiz" do
    get    "choose"
    post   "start"
    get    "play"
    put    "save_answer"
    match  "next_question", via: [:put, :get]
    get    "results"
    delete "finish"
  end

  resources :surveys, only: [:new, :create]

  ########################
  # Static pages
  ########################
  controller :static_pages do
    get "tour"
    get "contact"
  end
  get "blog", to: "posts#index"

  ########################
  # Admin
  ########################
  get "admin", to: "admin/schools#index"
  namespace :admin do
    resources :schools
  end
  resources :posts

  ########################
  # Error pages
  ########################
  controller :errors do
    get ":code", to: :show, constraints: {code: /\d+/}
  end

end
