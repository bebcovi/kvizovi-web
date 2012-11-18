class SchoolsController < ApplicationController
  def new
    if flash[:authorized]
      @school = School.new
    else
      redirect_to authorize_path
    end
  end

  def create
    @school = School.new(params[:school])

    if @school.save
      log_in!(@school)
      @school.create_example_quizzes
      redirect_to quizzes_path, notice: flash_message(:notice)
    else
      render :new
    end
  end

  def show
    @school = current_user
  end

  def edit
    @school = current_user
  end

  def update
    @school = current_user

    if @school.update_attributes(params[:school])
      redirect_to @school, notice: flash_message(:notice)
    else
      render :edit
    end
  end

  def delete
    @school = current_user
  end

  def destroy
    @school = current_user

    if @school.authenticate(params[:school][:password])
      @school.destroy
      log_out!
      redirect_to root_path, notice: flash_message(:notice)
    else
      flash.now[:alert] = flash_message(:alert)
      render :delete
    end
  end
end
