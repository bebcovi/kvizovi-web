require "spec_helper_lite"
Dir["#{ROOT}/app/models/**/*.rb"].each { |f| require f }

FactoryGirl.factories.map(&:name).each do |factory_name|
  describe "The #{factory_name} factory" do
    subject { build(factory_name) }
    use_nulldb

    it { should be_valid }
  end
end
