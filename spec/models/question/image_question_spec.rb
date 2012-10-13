require "spec_helper_lite"
require_relative "../../../app/models/question/image_question"

describe ImageQuestion do
  before(:each) { @it = build(:image_question) }
  subject { @it }

  use_nulldb

  it { should be_a(TextQuestion) }

  its(:points) { should eq 3 }

  describe "#image" do
    its(:image) { should be_file }
    its(:image) { should respond_to(:url) }

    it "can receive a URL" do
      @it.image_url = "https://dl.dropbox.com/u/16783504/image.jpg"
      @it.send(:assign_image)
      @it.image_file_name.should eq "image.jpg"
    end
  end

  describe "validations" do
    before(:each) do
      # Paperclip want to use this when setting the attachment to nil
      stub_const("Rails", Module.new)
      Rails.stub(:root)
    end

    it "can't have a blank image" do
      @it.image = nil
      @it.should_not be_valid
    end

    it "validates the URL" do
      @it.image_url = "invalid URL"
      @it.should_not be_valid
    end

    it "accepts either file or an URL as the image" do
      @it.image_url = "https://dl.dropbox.com/u/16783504/image.jpg"
      @it.should be_valid

      @it.image_url = nil
      @it.image_file = Rack::Test::UploadedFile.new("#{ROOT}/spec/fixtures/files/image.jpg")
      @it.should be_valid
    end
  end
end
