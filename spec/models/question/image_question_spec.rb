require "spec_helper_lite"
use_nulldb { require_relative "../../../app/models/question/image_question" }

describe ImageQuestion do
  before(:all) { Paperclip.options[:log] = false }

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
        @it.image_url = "http://designyoutrust.com/wp-content/uploads2/bla.jpg"
        @it.image_file_name.should eq "bla.jpg"
      end

      it "can receive a file" do
        @it.image = nil
        @it.image_file = Rack::Test::UploadedFile.new("#{ROOT}/spec/fixtures/files/image.jpg", "image/jpeg")
        @it.image_file_name.should eq "image.jpg"
      end
    end

    it "saves sizes" do
      @it.image_width.should be_a(Integer)
      @it.image_height.should be_a(Integer)
      @it.image_width(:resized).should be_a(Integer)
      @it.image_height(:resized).should be_a(Integer)
    end
  end

  describe "validations" do
    it "can't have a blank image" do
      @it.image = nil
      @it.should_not be_valid
    end

    it "validates the URL" do
      @it.image = nil
      @it.image_url = "invalid URL"
      @it.should_not be_valid
    end
  end
end
