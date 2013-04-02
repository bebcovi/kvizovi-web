class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :subdomain_view_path

  protected

  include Lektire::Authentication::ApplicationControllerMethods

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

  def school(&block)  yield if school?  end
  def student(&block) yield if student? end

  private

  def subdomain_view_path
    prepend_view_path "app/views/#{request.subdomain}" if request.subdomain.present?
  end

  def sub_layout
    "application"
  end
end
