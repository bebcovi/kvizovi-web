require "spec_helper"
require "active_support/core_ext/numeric/bytes"

describe ImageQuestion do
  enable_paper_trail

  before do
    @it = Factory.build(:image_question)
  end

  describe "#image_url=" do
    it "assigns the URL to #image" do
      @it.image_url = "http://designyoutrust.com/wp-content/uploads2/bla.jpg?q=2"
      expect(@it.image).to be_present
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
      @it.image_file = uploaded_file("image.jpg", "image/jpeg")
      expect(@it.image).to be_present
    end

    it "removes special characters from filenames" do
      @it.image_file = uploaded_file("image.jpg", "image_ščćžđ.jpg", "image/jpeg")
      expect(@it.image_file_name).to eq "image_scczd.jpg"
    end
  end

  context "callbacks" do
    it "saves image sizes" do
      @it.image = uploaded_file("image.jpg", "image/jpeg")
      @it.save!(validate: false)
      expect(@it.image_width).to be_a(Integer)
      expect(@it.image_height).to be_a(Integer)
      expect(@it.image_width(:resized)).to be_a(Integer)
      expect(@it.image_height(:resized)).to be_a(Integer)
    end

    it "keeps image sizes on update" do
      @it.image = uploaded_file("image.jpg", "image/jpeg")
      @it.save!(validate: false)
      @it.content = "Content"
      @it.save!(validate: false)
      expect(@it.image_width).to be_present
    end

    it "can revert destroy" do
      @it = Factory.create(:image_question, image: uploaded_file("image.jpg", "image/jpeg"))
      @it.destroy
      @it = @it.versions.last.reify
      @it.save!(validate: false)
      expect(@it.image.path).to satisfy { |path| File.exists?(path) }
      expect(@it.image_width).to be_present
    end
  end

  context "validations" do
    context "#image" do
      it "validates presence" do
        @it.image = nil
        expect(@it).to have(1).error_on(:image)
      end

      it "validates content type" do
        @it.image = create_file("video.mp4", "video/mp4")
        expect(@it).to have(1).error_on(:image_content_type)
      end

      it "validates size" do
        @it.image = create_file("image.jpg", "image/jpeg", size: 2.megabytes)
        expect(@it).to have(1).error_on(:image_file_size)
      end

      it "validates the image URL" do
        @it.image_url = "invalid url"
        expect(@it).to have(1).error_on(:image_url)
      end
    end
  end
end
