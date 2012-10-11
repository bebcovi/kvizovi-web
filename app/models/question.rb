require "active_record"

class Question < ActiveRecord::Base
  attr_accessible :content, :hint

  belongs_to :quiz

  validates_presence_of :content

  default_scope order("#{table_name}.created_at DESC")

  CATEGORIES = %w[boolean choice association image text]

  def self.categories
    CATEGORIES
  end

  CATEGORIES.each do |category|
    define_method("#{category}?") do
      self.category == category
    end
  end

  def category
    self.class.name.underscore.chomp("_question")
  end

  def to_partial_path
    "questions/#{self.class.name.underscore}"
  end

  def randomize!
    @randomized = true
    self
  end

  def randomize
    dup.randomize!
  end

  def randomized?
    !!@randomized
  end
end
