class School::SessionsController < School::BaseController
  def new
    @login = Login.new
  end

  def create
    @login = Login.new(params[:login])
    @login.user_class = School

    if @login.valid?
      log_in!(@login.user, permanent: @login.remember_me?)
      redirect_to return_point
    else
      set_alert_message
      render :new
    end
  end

  def destroy
    log_out!
    redirect_to root_url(subdomain: false)
  end
end
