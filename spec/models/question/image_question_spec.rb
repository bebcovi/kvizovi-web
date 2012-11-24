# encoding: utf-8
require "spec_helper_lite"
use_nulldb { require_relative "../../../app/models/question/image_question" }

describe ImageQuestion do
  before(:each) { stub_for_paperclip }
  before(:each) { @it = build(:image_question) }
  subject { @it }

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
        @it.image_file = uploaded_file("image.jpg", "image/jpeg")
        @it.save
        File.basename(@it.image.url.match(/\?\d+$/).pre_match).should eq "image.jpg"
        @it.send(:prepare_for_destroy)
        @it.send(:destroy_attached_files)
      end
    end

    it "saves sizes" do
      @it.image_width.should be_a(Integer)
      @it.image_height.should be_a(Integer)
      @it.image_width(:resized).should be_a(Integer)
      @it.image_height(:resized).should be_a(Integer)
    end

    it "removes special characters from filenames" do
      @it.image_file = uploaded_file("image_ščćžđ.jpg", "image/jpeg")
      @it.save
      File.basename(@it.image.url.match(/\?\d+$/).pre_match).should eq "image_scczd.jpg"
      File.exists?(File.join("#{ROOT}/public", "#{@it.image.url.match(/\?\d+$/).pre_match}")).should be_true
      @it.send(:prepare_for_destroy)
      @it.send(:destroy_attached_files)
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
