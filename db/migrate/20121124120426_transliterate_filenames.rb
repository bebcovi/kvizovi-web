require "active_support/inflector/transliterate"

class TransliterateFilenames < ActiveRecord::Migration
  include ActiveSupport::Inflector

  class Question < ActiveRecord::Base
  end
  class ImageQuestion < Question
  end

  def up
    ActiveRecord::Base.record_timestamps = false
    ImageQuestion.all.each do |question|
      question.update_attributes(image_file_name: transliterate(question.image_file_name))
    end
    ActiveRecord::Base.record_timestamps = true
  end

  def down
  end
end
