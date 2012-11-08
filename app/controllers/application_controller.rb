# encoding: utf-8

class ApplicationController < ActionController::Base
  before_filter :set_notification, if: proc {
    user_logged_in? and current_user.is_a?(School) and not current_user.notified?
  }

  protected

  def log_in!(user, options = {})
    if options[:permanent]
      cookies.permanent[:user_id] = user.id
      cookies.permanent[:user_type] = user.class.name.underscore
    else
      cookies[:user_id] = user.id
      cookies[:user_type] = user.class.name.underscore
    end
  end

  def log_out!
    cookies.delete(:user_id)
    cookies.delete(:user_type)
  end

  def user_logged_in?
    cookies[:user_id].present?
  end
  helper_method :user_logged_in?

  def current_user
    @current_user ||= user_class.find(cookies[:user_id])
  end
  helper_method :current_user

  def user_class
    cookies[:user_type].camelize.constantize
  end

  def authenticate!
    redirect_to root_path if not user_logged_in?
  end

  [:alert, :notice].each do |flash_name|
    define_method(flash_name) do |*args|
      options = args.extract_options!
      controller = params[:controller]
      action = args.first || params[:action]
      t("flash.#{controller}.#{action}.#{flash_name}", options)
    end
  end

  def set_notification
    flash.now[:notification] = "Napravili smo neke važne promijene, možete ih vidjeti #{view_context.link_to "ovdje", notifications_path}."
  end
end
