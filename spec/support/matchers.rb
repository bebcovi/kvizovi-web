require "rspec/expectations"

RSpec::Matchers.define :have_alert_message do
  match do |flash|
    flash[:alert].present? and flash[:alert] !~ /translation missing/
  end
end

RSpec::Matchers.define :have_notice_message do
  match do |flash|
    flash[:notice].present? and flash[:notice] !~ /translation missing/
  end
end
