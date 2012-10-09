ROOT = File.expand_path("../", File.dirname(__FILE__))
Dir["#{ROOT}/spec/support/**/*.rb"].each { |f| require f }

require "factory_girl"
Dir["#{ROOT}/spec/factories/**/*.rb"].each { |f| require f }

require "paperclip"
Paperclip.options[:log] = false

require "debugger"

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include UnitSpecHelpers
  config.include NullDBSpecHelpers
end

def stub_class(full_name, &block)
  klass = full_name.split("::").inject(Object) do |context, name|
    begin
      context.const_get(name)
    rescue NameError
      context.const_set(name, Class.new)
    end
  end

  if block_given?
    klass.class_eval(&block)
  end

  klass
end
