require "paperclip"
require "open-uri"

class AssignImageSizes < ActiveRecord::Migration
  class Question < ActiveRecord::Base
    serialize :data, Hash
  end

  class ImageQuestion < Question
  end

  def up
    ImageQuestion.find_each do |question|
      if question.image_size.values.empty?
        sizes = question.image.styles.inject({}) do |result, (style, _)|
          image = open(question.image.url(style))
          geometry = Paperclip::Geometry.from_file(image)
          result.update(style => {width: geometry.width.to_i, height: geometry.height.to_i})
        end
        question.update_attributes!(
          data: question.data.merge(image_size: sizes)
        )
      end
    end
  end

  def down
  end
end
