require "active_support/concern"

module Lektire::Authentication
  module ApplicationControllerMethods
    extend ActiveSupport::Concern

    included do
      helper_method :current_user
      helper_method :user_logged_in?
    end

    def current_user
      @current_user ||= user_class.find(cookies.signed[:user_id])
    end

    def user_logged_in?
      cookies.signed[:user_id].present? and
      cookies.signed[:user_type].present? and
      user_class.exists?(cookies.signed[:user_id])
    end

    def user_class
      if cookies.signed[:user_type].present?
        cookies.signed[:user_type].camelize.constantize
      else
        request.subdomain.camelize.constantize
      end
    end

    def authenticate!
      if not user_logged_in?
        set_return_point
        redirect_to login_path
      end
    end

    def set_return_point
      cookies[:return_to] = {
        value:   request.fullpath,
        expires: 5.minutes.from_now,
      }
    end

    def return_point
      cookies.delete(:return_to) || root_path
    end
  end
end
