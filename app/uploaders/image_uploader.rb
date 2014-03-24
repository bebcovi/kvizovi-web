class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def default_url
   "patterns/skulls/skulls-#{version_name}.png" if model.is_a?(Quiz)
  end

  resize_to_fill 800, 800

  version :medium do
    resize_to_fill 300, 300
  end

  version :small do
    resize_to_fill 150, 150
  end
end
