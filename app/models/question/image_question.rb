require_relative "text_question"
require "paperclip"

class ImageQuestion < TextQuestion
  attr_accessible :image

  include Paperclip::Glue
  has_attached_file :image, styles: {resized: "x250>"}

  validates :image, attachment_presence: true

  def points
    3
  end
end
