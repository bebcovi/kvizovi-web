require "squeel"
require "acts_as_list"

class Question < ActiveRecord::Base
  CATEGORIES = %w[boolean choice association text]
  NO_ANSWER  = "NO_ANSWER"

  belongs_to :quiz

  acts_as_list scope: :quiz
  mount_uploader :image, ImageUploader

  default_scope -> { order{position.asc} }

  validates :content, presence: true
  validates :image,   download: true, processing: true
end
