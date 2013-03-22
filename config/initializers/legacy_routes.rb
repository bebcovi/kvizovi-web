Lektire::Application.routes.draw do
  get "login",        to: redirect("")
  get "schools/new",  to: redirect("registrations/new?type=school")
  get "students/new", to: redirect("registrations/new?type=student")
end
