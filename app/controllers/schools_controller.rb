class SchoolsController < ApplicationController
  def show
    @school = current_user
  end

  def edit
    @school = current_user
  end

  def update
    @school = current_user

    if @school.valid?
      @school.update_attributes(params[:school])
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

    if UserAuthenticator.new(@school).authenticate(params[:password])
      @school.destroy
      log_out!
      redirect_to root_path, notice: flash_message(:notice)
    else
      set_alert_message
      render :delete
    end
  end
end
