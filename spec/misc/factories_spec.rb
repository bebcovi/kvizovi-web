require "spec_helper_lite"
use_nulldb { Dir["#{ROOT}/app/models/**/*.rb"].each { |f| require f } }

FactoryGirl.factories.map(&:name).each do |factory_name|
  describe "The #{factory_name} factory" do
    before(:each) do
      # Paperclip want to use this when assigning the attachment
      stub_const("Rails", Module.new)
      Rails.stub(:root)
    end

    subject { build(factory_name) }
    use_nulldb

    it { should be_valid }
  end
end
