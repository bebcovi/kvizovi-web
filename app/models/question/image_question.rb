require_relative "text_question"
require_relative "data/image_question_data"

class ImageQuestion < TextQuestion
  delegate :image, to: :data

  def points
    3
  end
end
