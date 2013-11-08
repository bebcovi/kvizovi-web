class Account::QuizzesController < InheritedResources::Base
  actions :all, except: [:show]
  respond_to :html, :js
  before_action :authenticate_user!

  private

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
