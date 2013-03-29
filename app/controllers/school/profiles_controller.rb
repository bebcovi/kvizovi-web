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
end
