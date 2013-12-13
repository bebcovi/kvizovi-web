class Account::QuizzesController < InheritedResources::Base
  respond_to :html, :js

  before_action :authenticate_school!

  actions :all, except: [:show]

  private

  def resource_url
    account_quiz_questions_path(@quiz)
  end

  def begin_of_association_chain
    current_user
  end

  def collection
    @quizzes = end_of_association_chain.order{updated_at.desc}
  end

  def permitted_params
    params.permit!
  end
end
