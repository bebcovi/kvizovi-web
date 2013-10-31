require "squeel"
require "acts_as_list"

class Question < ActiveRecord::Base
  CATEGORIES = %w[boolean choice association image text]
  NO_ANSWER  = "NO_ANSWER"

  belongs_to :quiz

  acts_as_list scope: :quiz

  default_scope -> { order{position.asc} }

  validates :content, presence: true
end
