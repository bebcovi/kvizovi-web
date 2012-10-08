require "spec_helper_lite"
require_relative "../../../app/models/question/image_question"

# Paperclip want to use this when setting the attachment to nil
module Rails
  def self.root
  end
end unless defined?(Rails)

describe ImageQuestion do
  before(:each) { @it = build(:image_question) }
  subject { @it }

  use_nulldb

  it { should be_a(TextQuestion) }

  its(:points) { should eq 3 }

  describe "#image" do
    its(:image) { should be_file }
    its(:image) { should respond_to(:url) }
  end

  describe "validations" do
    it "can't have a blank image" do
      @it.image = nil
      @it.should_not be_valid
    end
  end
end
