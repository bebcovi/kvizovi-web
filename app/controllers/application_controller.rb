class ApplicationController < ActionController::Base
  protect_from_forgery

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

  def current_user
    @current_user ||= user_class.find(cookies.signed[:user_id])
  end
  helper_method :current_user

  def user_logged_in?
    cookies[:user_id].present? and
    cookies[:user_type].present? and
    user_class.exists?(cookies.signed[:user_id])
  end
  helper_method :user_logged_in?

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
    cookies[:return_to] || root_path
  end

  def flash_message(type, *args)
    options = args.extract_options!
    controller = params[:controller]
    action = args.first || params[:action]

    t("flash.#{controller}.#{action}.#{type}", options)
  end

  def set_alert_message(*args)
    flash.now[:alert] = flash_message(:alert, *args)
  end

  def render(*args)
    options = args.extract_options!
    options.update(layout: false) if request.headers["X-noLayout"]
    args << options
    super
  end

  private

  def sub_layout
    "application"
  end

  def user_class
    cookies.signed[:user_type].camelize.constantize
  end
end
