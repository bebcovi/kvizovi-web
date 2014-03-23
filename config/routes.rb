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

  resources :quizzes, only: [:index, :show] do
    member do
      post   "start"
      get    "play"
      put    "save_answer"
      put    "next_question"
      get    "results"
      delete "finish"
    end
  end

  resources :surveys, only: [:new, :create]

  ########################
  # Static pages
  ########################
  get "blog", to: "posts#index"
  post "contact", to: "home#contact"

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
