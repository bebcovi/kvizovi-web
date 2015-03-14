RSpec::Matchers.define :be_a_nonempty do |klass|
  match do |object|
    object.is_a?(klass) && !object.empty?
  end
end

module TestHelpers
  def self.const_missing(name)
    require_relative "test_helpers/#{name.downcase}"
    TestHelpers.const_get(name)
  end
end
