require_relative "text_question"
require "paperclip"
require "active_support/core_ext/numeric/bytes"
require "uri"

class ImageQuestion < TextQuestion
  data_accessor *Paperclip::Schema::COLUMNS.keys.map { |name| :"image_#{name}" }, :image_size
  attr_accessor :image_url, :image_file

  serialize :image_size, Hash

  include Paperclip::Glue
  has_attached_file :image, styles: {resized: "x250>"},
    dropbox_options: { path: ->(style) { "lektire/#{id}_#{image.original_filename}" } }

  def image_width(style = :original)  image_size[style][:width] end
  def image_height(style = :original) image_size[style][:height] end

  after_initialize :assign_image

  validates_format_of :image_url, with: URI.regexp, allow_blank: true
  validates_attachment :image, presence: true, size: {less_than_or_equal_to: 1.megabyte}

  before_save :assign_image, unless: -> { image.present? }
  before_save :assign_image_sizes

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
    true
  end

  def assign_image_sizes
    size = {}
    image.instance_variable_get("@queued_for_write").each do |style, file|
      geometry = Paperclip::Geometry.from_file(file)
      size[style] = {width: geometry.width.to_i, height: geometry.height.to_i}
    end
    self.image_size = size
  end
end
