RSpec::Matchers.define :be_valid do
  match do |record|
    record.valid?
  end

  failure_message_for_should do |record|
    <<-MESSAGE
expected #{record.inspect} to be valid, but got these errors:

#{record.errors.messages.inspect}
    MESSAGE
  end

  failure_message_for_should_not do |record|
    "expected #{record.inspect} to not be valid"
  end
end
