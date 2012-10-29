# encoding: utf-8

class PasswordsController < ApplicationController
  def new
  end

  def create
    if school = School.find_by_email(params[:email])
      new_password = school.reset_password
      PasswordResetNotifier.password_reset(school, new_password).deliver
      redirect_to root_path, notice: "Nova lozinka je poslana na vaš email."
    else
      flash.now[:alert] = "Škola s tom email adresom nije nađena."
      render :new
    end
  end

  def edit
    @password = Password.new
  end

  def update
    @password = Password.new(params[:password].merge(user: current_user))

    if @password.save
      redirect_to current_user, notice: "Lozinka je uspješno izmjenjena."
    else
      render :edit
    end
  end
end
