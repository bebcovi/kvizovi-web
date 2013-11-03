class Account::QuizzesController < InheritedResources::Base
  actions :all, except: [:show]
  before_filter :authenticate_user!

  private

  def begin_of_association_chain
    current_user
  end

  def permitted_params
    params.permit!
  end
end
