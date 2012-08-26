# encoding: utf-8

class PasswordsController < ApplicationController
  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.authenticate(params[:old_password])
      if @user.update_attributes(user_params)
        redirect_to @user, notice: "Lozinka je uspješno izmjenjena."
      else
        render :edit
      end
    else
      flash.now[:alert] = "Stara lozinka nije ispravna."
      render :edit
    end
  end

  private

  def user_params
    params[:student] or params[:school]
  end
end
