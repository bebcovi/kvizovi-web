Rails.application.routes.draw do
  scope constraints: {subdomain: /school|student/} do
    controller :sessions do
      get   "login",  to: :new
      post  "login",  to: :create
      match "logout", to: :destroy
    end
    resource :registration
    resource :authorization
    resource :password_reset
  end

  ########################
  # Legacy routes
  ########################
  get "login",        to: redirect(                      path: "/")
  get "schools/new",  to: redirect(subdomain: "school",  path: "/registration/new")
  get "students/new", to: redirect(subdomain: "student", path: "/registration/new")
end
