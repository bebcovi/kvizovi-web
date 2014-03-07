class Account::QuizzesController < InheritedResources::Base
  actions :all, except: [:show]
  respond_to :html, :js
  before_action :authenticate_school!
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    @quiz = build_resource
    super
  end

  private

  def collection
    @quizzes = current_user.quizzes.order{updated_at.desc}
  end

  def permitted_params
    params.permit!
  end

  def authorize_user!
    if not collection.include?(resource)
      redirect_to action: :index, error: "Nemate dozvoljen pristup ovom kvizu."
    end
  end
end
