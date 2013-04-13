require "delegate"

class BasePresenter < SimpleDelegator
  def initialize(object, template)
    super(object)
    @t = template
  end

  def self.presents(name)
    define_method(name) do
      __getobj__
    end
  end
end
