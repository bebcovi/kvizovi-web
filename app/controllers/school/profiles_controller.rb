class School::ProfilesController < School::BaseController
  before_filter :authenticate!

  def show
    @school = current_user
  end

  def edit
    @school = current_user
  end

  def update
    @school = current_user
    @school.assign_attributes(params[:school])

    if @school.valid?
      @school.save
      redirect_to profile_path, notice: flash_message(:notice)
    else
      render :edit
    end
  end

  def delete
    @school = current_user
  end

  def destroy
    @school = current_user

    if @school.authenticate(params[:password])
      @school.destroy
      log_out!
      redirect_to root_url(subdomain: false), notice: flash_message(:notice)
    else
      set_alert_message
      render :delete
    end
  end
end
