class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include ActionView::Helpers::AssetUrlHelper

  def default_url
    case model
    when Quiz
      case version_name
      when :small  then asset_path("assets/patterns/skulls/skulls-small.png")
      when :medium then asset_path("assets/patterns/skulls/skulls-medium.png")
      end
    end
  end

  resize_to_fill 800, 800

  version :medium do
    resize_to_fill 300, 300
  end

  version :small do
    resize_to_fill 150, 150
  end
end
