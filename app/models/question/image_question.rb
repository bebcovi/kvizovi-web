require_relative "text_question"
require "paperclip"
require "uri"

class ImageQuestion < TextQuestion
  attr_accessible :image_url, :image_file
  attr_accessor :image_url, :image_file

  include Paperclip::Glue
  has_attached_file :image, styles: {resized: "x250>"}

  before_validation :assign_image

  validates_format_of :image_url, with: URI.regexp, allow_blank: true
  validates :image, attachment_presence: true

  def points
    3
  end

  private

  def assign_image
    if image_file.present?
      self.image = image_file
    elsif image_url.present?
      begin
        self.image = URI.parse(image_url)
      rescue
      end
    end
  end
end
