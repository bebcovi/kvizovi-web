class ApplicationController < ActionController::Base
  protect_from_forgery

  protected

  def log_in!(user, options = {})
    if not options[:permanent]
      cookies[:user_id] = user.id
    else
      cookies.permanent[:user_id] = user.id
    end
  end

  def log_out!
    cookies.delete(:user_id)
  end

  def user_logged_in?
    false
  end
  helper_method :user_logged_in?

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
end
