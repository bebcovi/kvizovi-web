class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  resize_to_limit nil, 800

  version :resized do
    resize_to_limit 300, nil
  end
end
