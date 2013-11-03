class Account::ProfilesController < InheritedResources::Base
  before_action :authenticate_user!

  private

  def resource
    @user ||= current_user
  end

  def resource_instance_name
    resource.type
  end

  def permitted_params
    params.permit!
  end
end
