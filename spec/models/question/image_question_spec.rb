require "spec_helper"
require "active_support/core_ext/numeric/bytes"

describe ImageQuestion do
  before(:all) do
    @it = build(:image_question)
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
      transaction_with_rollback { @it.save }
      @it.image_width.should be_a(Integer)
      @it.image_height.should be_a(Integer)
      @it.image_width(:resized).should be_a(Integer)
      @it.image_height(:resized).should be_a(Integer)
    end
  end

  context "validations" do
    reset_attributes(FactoryGirl.attributes_for(:image_question))

    context "#image" do
      it "validates presence" do
        expect { @it.image = nil }.to invalidate(@it)
      end

      it "validates content type" do
        create_file("video.mp4", "video/mp4") do |not_image|
          expect { @it.image = not_image }.to invalidate(@it)
        end
      end

      it "validates size" do
        create_file("image.jpg", "image/jpeg", size: 2.megabytes) do |image|
          expect { @it.image = image }.to invalidate(@it)
        end
      end

      it "validates the image URL" do
        expect { @it.image_url = "invalid url" }.to invalidate(@it)
      end
    end
  end
end
