class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def default_url
    case model
    when Quiz
      case version_name
      when :small  then "http://placekitten.com/80/80"
      when :medium then "http://placekitten.com/300/300"
      end
    end
  end

  resize_to_limit nil, 800

  version :medium do
    resize_to_limit 300, nil
  end

  version :small do
    resize_to_limit nil, 150
  end
end
