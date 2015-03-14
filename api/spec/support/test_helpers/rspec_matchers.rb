RSpec::Matchers.define :be_a_nonempty do |klass|
  match do |object|
    object.is_a?(klass) && !object.empty?
  end
end
