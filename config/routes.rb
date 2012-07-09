Lektire::Application.routes.draw do

  match "404", to: "errors#not_found"
  match "500", to: "errors#internal_server_error"
end
