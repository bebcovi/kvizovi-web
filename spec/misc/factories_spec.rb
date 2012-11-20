require "spec_helper_lite"
use_nulldb { Dir["#{ROOT}/app/models/**/*.rb"].each { |f| require f } }

FactoryGirl.factories.map(&:name).each do |factory_name|
  describe "The #{factory_name} factory" do
    before(:each) { setup_paperclip }

    subject { build(factory_name) }
    use_nulldb

    it { should be_valid }
  end
end
