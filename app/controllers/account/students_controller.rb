class Account::StudentsController < InheritedResources::Base
  before_action :authenticate_school!

  actions :all, except: [:show]

  private

  def begin_of_association_chain
    current_user
  end
end
