class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_filter :add_user_view_path, if: :user_logged_in?
  before_filter :save_activity, if: :user_logged_in?
  before_filter :force_filling_email, if: :user_logged_in?

  add_flash_types :success, :error, :warning

  def render(*args)
    options = args.extract_options!
    options.update(layout: false) if request.headers["X-noLayout"]
    args << options
    super
  end

  protected

  def current_user
    case
    when school_signed_in?  then current_school
    when student_signed_in? then current_student
    end
  end
  helper_method :current_user

  def user_logged_in?
    school_signed_in? or student_signed_in?
  end
  helper_method :user_logged_in?

  def authenticate_user!
    if not user_logged_in?
      redirect_to root_path, warning: "Niste prijavljeni."
    end
  end

  def flash_success(*args) flash_message(:success, *args) end
  def flash_error(*args)   flash_message(:error, *args)  end

  def flash_message(type, *args)
    options = args.extract_options!
    action = args.first || params[:action]
    controller = params[:controller]

    path = "flash"
    path << ".#{current_user.type}" if user_logged_in?
    path << ".#{controller}.#{action}.#{type}"

    t(path, options)
  end

  def set_flash_error(*args)
    flash.now[:error] = flash_error(*args)
  end

  def after_sign_in_path_for(resource_or_scope)
    account_path
  end

  def add_user_view_path
    prepend_view_path "app/views/#{current_user.type.pluralize}" unless devise_controller?
  end

  def save_activity
    LastActivity.for(current_user).save(Time.now)
  end

  def force_filling_email
    if current_user.email.blank? and params[:controller] != "account/profiles"
      redirect_to edit_account_profile_path, warning: "Od sada nadalje nam treba tvoja email adresa, pa molimo da je ispuniš ispod."
    end
  end

  def devise_parameter_sanitizer
    DeviseParameterSanitizer.new(resource_class, resource_name, params)
  end

  class DeviseParameterSanitizer < Devise::ParameterSanitizer
    def sign_in
      default_params.permit!
    end

    def sign_up
      default_params.permit!
    end

    def account_update
      default_params.permit!
    end
  end
end
