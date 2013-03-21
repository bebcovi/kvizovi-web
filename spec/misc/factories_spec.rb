require "spec_helper"

FactoryGirl.factories.map(&:name).each do |factory_name|
  describe "The #{factory_name} factory" do
    before do
      @it = build(factory_name)
    end

    it "is valid" do
      expect(@it).to be_valid
    end
  end
end
