# encoding: utf-8

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
      redirect_to quizzes_path, notice: "Uspješno ste se registrirali."
    else
      render :new
    end
  end

  def show
    @school = current_school
  end

  def edit
    @school = current_school
  end

  def update
    @school = current_school

    if @school.update_attributes(params[:school])
      redirect_to @school, notice: "Vaš profil je uspješno izmijenjen."
    else
      render :edit
    end
  end

  def notify
    current_school.update_attributes(notified: true)
    redirect_to :back
  end

  def delete
    @school = current_school
    render layout: false if request.headers["X-fancyBox"]
  end

  def destroy
    @school = current_school

    if @school.authenticate(params[:school][:password])
      @school.destroy
      log_out!
      redirect_to root_path, notice: "Vaš korisnički račun je uspješno izbrisan."
    else
      flash.now[:alert] = "Lozinka nije točna."
      render :delete
    end
  end
end
