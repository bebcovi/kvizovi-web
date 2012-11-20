require "spec_helper_full"

describe Question do
  before(:all) { @it = create(:question) }
  subject { @it }

  describe "#dup" do
    it "copies tags" do
      @it.update_attributes(tag_list: ["bar", "foo"])
      Question.find(@it.id).dup.tag_list.split(", ").sort.should eq ["bar", "foo"]
    end
  end

  after(:all) { @it.destroy }
end
