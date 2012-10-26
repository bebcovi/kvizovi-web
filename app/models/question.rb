require "active_record"

class Question < ActiveRecord::Base
  def self.inherited(base)
    super

    base.class_eval do
      belongs_to :data, class_name: "#{name}Data", dependent: :destroy
      attr_accessible :data_attributes
      validates_associated :data

      after_initialize { self.data ||= build_data }
    end

    base.accepts_nested_attributes_for :data if self == Question
  end

  attr_accessible :content, :hint

  belongs_to :quiz, touch: true

  validates_presence_of :content

  def self.categories
    %w[boolean choice association image text]
  end

  categories.each do |category|
    define_method("#{category}?") do
      self.category == category
    end
  end

  def category
    type.underscore.chomp("_question")
  end

  def randomize!
    self
  end

  def randomize
    dup.randomize!
  end

  def to_partial_path
    "questions/#{category}_question"
  end
end
