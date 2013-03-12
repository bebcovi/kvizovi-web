class AuthorizationsController < ApplicationController
  def new
    @authorization = Authorization.new
  end

  def create
    @authorization = Authorization.new(params[:authorization])

    if @authorization.valid?
      flash[:authorized] = true
      redirect_to new_registration_path(type: "school"), notice: flash_message(:notice)
    else
      set_alert_message
      render :new
    end
  end
end
