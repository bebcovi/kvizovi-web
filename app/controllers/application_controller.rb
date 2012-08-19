class ApplicationController < ActionController::Base
  def self.authentication_methods(*args)
    options = args.last.is_a?(Hash) ? args.pop : {}
    names = args.map(&:to_s)
    the_name = options[:as] || names.first

    define_method("current_#{the_name}") do
      return instance_variable_get("@current_#{the_name}") if instance_variable_get("@current_#{the_name}")

      record = names.map do |name|
        if cookies[:"#{name}_id"]
          break name.camelize.constantize.find(cookies[:"#{name}_id"])
        end
      end
      record = nil if record.is_a?(Array)
      instance_variable_set("@current_#{the_name}", record)
    end
    helper_method :"current_#{the_name}"

    define_method("#{the_name}_logged_in?") do
      names.any? { |name| cookies[:"#{name}_id"].present? }
    end
    define_method("#{the_name}_not_logged_in?") do
      not send("#{the_name}_logged_in?")
    end
    helper_method :"#{the_name}_logged_in?", :"#{the_name}_not_logged_in?"

    define_method("authenticate_#{the_name}!") do
      redirect_to login_path if send("#{the_name}_not_logged_in?")
    end
  end

  authentication_methods :school, :student, as: :user
  authentication_methods :school
  authentication_methods :student
end
