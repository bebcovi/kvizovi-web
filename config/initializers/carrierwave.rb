require_relative "credentials"

CarrierWave.configure do |config|
  if Rails.env.production? or Rails.env.staging?
    config.storage = :fog
    config.fog_credentials = {
      provider: "AWS",
      aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
      aws_secret_access_key: ENV["AWS_SECRET_KEY"],
      region: ENV["AWS_REGION"],
    }
    config.fog_directory = ENV["AWS_S3_BUCKET"]
    config.store_dir = ->(uploader) { "#{uploader.model.class.table_name.singularize}/#{uploader.model.id}/#{uploader.mounted_as}" }
    config.cache_dir = "tmp/uploads" # For Heroku
  else
    config.storage = :file
    config.store_dir = ->(uploader) { "uploads/#{uploader.model.class.table_name.singularize}/#{uploader.model.id}/#{uploader.mounted_as}" }
  end
end

require "carrierwave/validations/active_model"

# We need custom validation messages
module CarrierWave
  module Validations
    module ActiveModel

      class ProcessingValidator
        def validate_each(record, attribute, value)
          if record.send("#{attribute}_processing_error")
            record.errors.add(attribute, :processing)
          end
        end
      end

      class IntegrityValidator
        def validate_each(record, attribute, value)
          if record.send("#{attribute}_integrity_error")
            record.errors.add(attribute, :integrity)
          end
        end
      end

      class DownloadValidator
        def validate_each(record, attribute, value)
          if record.send("#{attribute}_download_error")
            record.errors.add(attribute, :download)
          end
        end
      end

    end
  end
end
