# encoding: utf-8

class PasswordsController < ApplicationController
  def edit
    @password = Password.new
  end

  def update
    @password = Password.new(params[:password], current_user)

    if @password.save
      redirect_to current_user, notice: "Lozinka je uspješno izmjenjena."
    else
      render :edit
    end
  end
end
