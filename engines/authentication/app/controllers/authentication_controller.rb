class AuthenticationController < ApplicationController
  before_filter :subdomain_view_path

  protected

  def log_in!(user, options = {})
    if not options[:permanent]
      cookies.signed[:user_id] = user.id
      cookies.signed[:user_type] = user.type
    else
      cookies.signed.permanent[:user_id] = user.id
      cookies.signed.permanent[:user_type] = user.type
    end
  end

  def log_out!
    cookies.delete(:user_id)
    cookies.delete(:user_type)
  end

  private

  def subdomain_view_path
    prepend_view_path "engines/authentication/app/views/#{request.subdomain}" if request.subdomain.present?
  end
end
