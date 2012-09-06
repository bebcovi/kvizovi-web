# encoding: utf-8

class AuthorizeController < ApplicationController
  def show
    render :authorize
  end

  def authorize
    if params[:secret_key] == ENV["LEKTIRE_KEY"]
      flash[:authorized] = true
      redirect_to new_school_path, notice: "Točno ste napisali ključ. Sada se možete registrirati :)"
    else
      flash.now[:alert] = "Ključ je netočan."
    end
  end
end
