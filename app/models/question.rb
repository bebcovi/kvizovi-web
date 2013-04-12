class Question < ActiveRecord::Base
  CATEGORIES = %w[boolean choice association image text]

  has_and_belongs_to_many :quizzes, foreign_key: "question_id"

  acts_as_taggable

  scope :search, ->(query) { scoped }

  validates :content, presence: true

  def self.data_accessor(*names)
    store :data, accessors: names
  end

  def dup
    super.tap do |question|
      question.tag_list = self.tag_list
    end
  end
end
