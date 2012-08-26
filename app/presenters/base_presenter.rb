class BasePresenter
  def initialize(object, template)
    @object = object
    @template = template
  end

  def self.presents(name)
    define_method(name) do
      @object
    end
  end

  def method_missing(name, *args, &block)
    if @object.respond_to?(name)
      @object.send(name, *args, &block)
    elsif @template.respond_to?(name)
      @template.send(name, *args, &block)
    else
      super
    end
  end
end
