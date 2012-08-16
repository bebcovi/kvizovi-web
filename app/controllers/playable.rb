module Playable

  include ActionMethods
  include HelperMethods

  def self.included(klass)
    klass.helper_method *(HelperMethods.instance_methods - Module.instance_methods)
  end
end
