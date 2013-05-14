class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :add_subdomain_view_path
  before_filter :mark_activity, if: :user_logged_in?

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
    cookies.signed[:user_id].present? and
    cookies.signed[:user_type].present? and
    user_class.exists?(cookies.signed[:user_id])
  end
  helper_method :user_logged_in?

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

  def flash_success(*args) flash_message(:success, *args) end
  def flash_error(*args)   flash_message(:error, *args)  end

  def flash_message(type, *args)
    options = args.extract_options!
    action = args.first || params[:action]
    controller = params[:controller]

    path = "flash"
    path << ".#{request.subdomain}" if request.subdomain
    path << ".#{controller}.#{action}.#{type}"

    t(path, options)
  end

  def set_flash_error(*args)
    flash.now[:alert] = flash_error(*args)
  end

  def render(*args)
    options = args.extract_options!
    options.update(layout: false) if request.headers["X-noLayout"]
    args << options
    super
  end

  def school?()  request.subdomain == "school"  end
  def student?() request.subdomain == "student" end
  helper_method :school?, :student?

  def root_path_for(user)
    case user
    when Student then choose_quiz_path
    when School  then quizzes_path
    end
  end

  private

  def add_subdomain_view_path
    prepend_view_path "app/views/#{request.subdomain}" if request.subdomain.present?
  end

  def mark_activity
    $redis.set("last_activity:school:#{current_user.username}", Time.now)
  end
end
