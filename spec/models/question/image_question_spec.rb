require "spec_helper"
require "active_support/core_ext/numeric/bytes"

describe ImageQuestion do
  before do
    @it = Factory.build(:empty_image_question)
  end

  describe "#image_url=" do
    it "assigns the URL to #image" do
      expect {
        @it.image_url = "http://designyoutrust.com/wp-content/uploads2/bla.jpg?q=2"
      }.to change{@it.image_file_name}.to "bla.jpg"
    end

    it "doesn't raise errors on invalid URLs" do
      expect { @it.image_url = "bla"            }.not_to raise_error
      expect { @it.image_url = "http://bla.bla" }.not_to raise_error
    end

    it "deassigns image on invalid URL" do
      @it.image_url = "bla"
      expect(@it.image).not_to be_present
    end
  end

  describe "#image_file=" do
    it "assigns file to #image" do
      @it.image = nil
      expect {
        @it.image_file = uploaded_file("image.jpg", "image/jpeg")
      }.to change{@it.image_file_name}.to "image.jpg"
    end

    it "removes special characters from filenames" do
      create_file("image_ščćžđ.jpg", "image/jpeg") do |image|
        @it.image_file = image
        expect(@it.image_file_name).to eq "image_scczd.jpg"
      end
    end
  end

  context "callbacks" do
    it "saves sizes" do
      @it.image = uploaded_file("image.jpg", "image/jpeg")
      @it.save(validate: false)
      expect(@it.image_width).to be_a(Integer)
      expect(@it.image_height).to be_a(Integer)
      expect(@it.image_width(:resized)).to be_a(Integer)
      expect(@it.image_height(:resized)).to be_a(Integer)
    end
  end

  context "validations" do
    context "#image" do
      it "validates presence" do
        @it.image = nil
        expect(@it).to have(1).error_on(:image)
      end

      it "validates content type" do
        create_file("video.mp4", "video/mp4") do |not_image|
          @it.image = not_image
          expect(@it).to have(1).error_on(:image_content_type)
        end
      end

      it "validates size" do
        create_file("image.jpg", "image/jpeg", size: 2.megabytes) do |image|
          @it.image = image
          expect(@it).to have(1).error_on(:image_file_size)
        end
      end

      it "validates the image URL" do
        @it.image_url = "invalid url"
        expect(@it).to have(1).error_on(:image_url)
      end
    end
  end
end
