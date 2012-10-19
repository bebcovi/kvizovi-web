require "spec_helper_lite"
require_relative "../../../app/models/question/image_question"

describe ImageQuestion do
  before(:each) { @it = build(:image_question) }
  subject { @it }

  before(:each) do
  # Paperclip want to use this when assigning the attachment
    stub_const("Rails", Module.new)
    Rails.stub(:root)
  end

  use_nulldb

  it { should be_a(TextQuestion) }

  describe "data" do
    describe "#image" do
      its(:image) { should be_file }
      its(:image) { should respond_to(:url) }

      it "can receive a URL" do
        @it.data.image_url = "https://dl.dropbox.com/u/16783504/image.jpg"
        @it.data.send(:assign_image)
        @it.data.image_file_name.should eq "image.jpg"
      end
    end
  end

  describe "validations" do
    it "can't have a blank image" do
      @it.data.image = nil
      @it.should_not be_valid
    end

    it "validates the URL" do
      @it.data.image_url = "invalid URL"
      @it.should_not be_valid
    end

    it "accepts either file or an URL as the image" do
      @it.data.image_url = "https://dl.dropbox.com/u/16783504/image.jpg"
      @it.should be_valid

      @it.data.image_url = nil
      @it.data.image_file = Rack::Test::UploadedFile.new("#{ROOT}/spec/fixtures/files/image.jpg")
      @it.should be_valid
    end
  end
end
