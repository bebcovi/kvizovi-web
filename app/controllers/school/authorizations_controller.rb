class School::AuthorizationsController < School::BaseController
  def new
    @authorization = Authorization.new
  end

  def create
    @authorization = Authorization.new(params[:authorization])

    if @authorization.valid?
      flash[:authorized] = true
      redirect_to new_registration_path, notice: flash_message(:notice)
    else
      render :new
    end
  end
end
