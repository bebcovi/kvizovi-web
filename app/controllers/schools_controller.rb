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

    if @school.valid?
      @school.save
      ExampleQuizzesCreator.new(@school).create
      log_in!(@school)
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

  def toggle_question_privacy
    @school = current_user
    @school.toggle!(:public_questions)
    flash[:notice] = if @school.public_questions?
                       "Vaša pitanja su sada javna, druge škole ih mogu vidjeti."
                     else
                       "Vaša pitanja su sada privatna, samo ih vi možete vidjeti."
                     end
    redirect_to @school
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
