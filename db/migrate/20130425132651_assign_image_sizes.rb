require "open-uri"

class AssignImageSizes < ActiveRecord::Migration
  class Question < ActiveRecord::Base
    serialize :data, Hash

    def self.data_accessor(*keys)
      include Module.new {
        keys.each do |key|
          define_method(key) do
            (data || {})[key]
          end

          define_method("#{key}=") do |value|
            self.data = (data || {}).merge(key => value)
          end
        end
      }
    end
  end

  class ImageQuestion < Question
    has_attached_file :image, styles: {resized: "x250>"}

    data_accessor :image_file_name, :image_content_type,
      :image_file_size, :image_updated_at, :image_size
  end

  def up
    handle_single_table_inheritance(Question) do
      ImageQuestion.find_each do |question|
        if question.data[:image_size].values.empty?
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
  end

  def down
  end
end
