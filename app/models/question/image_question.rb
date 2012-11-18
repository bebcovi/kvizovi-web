require_relative "text_question"
require "paperclip"
require "active_support/core_ext/numeric/bytes"
require "uri"
require "open-uri"

class ImageQuestion < TextQuestion
  data_accessor *Paperclip::Schema::COLUMNS.keys.map { |name| :"image_#{name}" }, :image_size

  serialize :image_size, Hash

  include Paperclip::Glue
  has_attached_file :image, styles: {resized: "x250>"},
    dropbox_options: { path: ->(style) { "lektire/#{id}_#{image.original_filename}" } }

  attr_reader :image_url, :image_file
  def image_url=(url)
    if url.present?
      @image_url = url
      begin
        self.image = URI.parse(url)
      rescue SocketError, URI::InvalidURIError
      end
    end
  end
  def image_file=(file)
    if file.present?
      @image_file = file
      self.image = file
    end
  end

  def image_width(style = :original)  image_size[style][:width] end
  def image_height(style = :original) image_size[style][:height] end

  validate :validate_image_url
  validates_attachment :image, presence: true, size: {less_than_or_equal_to: 1.megabyte}

  before_save :assign_image_sizes

  private

  def assign_image_sizes
    size = {}
    image.instance_variable_get("@queued_for_write").each do |style, file|
      geometry = Paperclip::Geometry.from_file(file)
      size[style] = {width: geometry.width.to_i, height: geometry.height.to_i}
    end
    self.image_size = size
  end

  def validate_image_url
    if image_url.present? and not image.present?
      errors[:image] << "Nije validna URL adresa."
    end
  end
end
