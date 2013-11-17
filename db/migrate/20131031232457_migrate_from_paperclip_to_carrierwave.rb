require "open-uri"
require "tempfile"

class MigrateFromPaperclipToCarrierwave < ActiveRecord::Migration
  class ImageUploader < CarrierWave::Uploader::Base
    include CarrierWave::MiniMagick

    resize_to_limit nil, 800

    version :medium do
      resize_to_limit 300, nil
    end

    version :small do
      resize_to_limit nil, 150
    end
  end

  class Question < ActiveRecord::Base
    mount_uploader :image, ImageUploader
  end

  class ImageQuestion < Question
    store :data, accessors: [:image_file_name]
  end

  def change
    if Rails.env.production? or Rails.env.staging?
      handle_sti(Question) do
        ImageQuestion.find_each do |question|
          url = "https://dl.dropboxusercontent.com/u/16783504/lektire/#{question.id}_#{question.image_file_name}"
          image = Tempfile.new(question.image_file_name, encoding: "ascii-8bit")
          image.write open(url).read
          question.update(image: image)
        end
      end
    end
  end
end
