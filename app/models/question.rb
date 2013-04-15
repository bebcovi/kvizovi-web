class Question < ActiveRecord::Base
  CATEGORIES = %w[boolean choice association image text]

  belongs_to :quiz

  acts_as_taggable

  scope :search,    ->(query) { scoped }
  scope :ascending, ->        { order{created_at.asc} }

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
