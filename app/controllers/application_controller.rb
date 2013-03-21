class ApplicationController < ActionController::Base
  protect_from_forgery

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
    cookies[:user_id].present? and cookies[:user_type].present? and user_class.exists?(cookies[:user_id])
  end
  helper_method :user_logged_in?

  def current_user
    if user_logged_in?
      @current_user ||= user_class.find(cookies[:user_id])
    end
  end
  helper_method :current_user

  def authenticate!
    if not user_logged_in?
      redirect_to root_path, alert: "Najprije se trebate prijaviti :)"
    end
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

  def user_class
    cookies[:user_type].camelize.constantize if cookies[:user_type]
  end

  def sub_layout
    "application"
  end
end
