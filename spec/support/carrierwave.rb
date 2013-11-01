require "fileutils"

CarrierWave::Uploader::Base.descendants.each do |uploader_class|
  uploader_class.class_eval do
    def store_dir
      "tmp/uploads"
    end

    def cache_dir
      "tmp/uploads/cache"
    end
  end
end

RSpec.configure do |config|
  config.after(:suite) do
    FileUtils.rm_rf Rails.root.join("tmp/uploads")
  end
end
