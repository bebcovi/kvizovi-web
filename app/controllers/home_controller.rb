class HomeController < ApplicationController
  def index
    render inline: "Hello World!"
  end
end
