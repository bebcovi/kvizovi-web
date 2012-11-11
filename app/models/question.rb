require "active_record"
require "activerecord-postgres-hstore"

class Question < ActiveRecord::Base
  has_and_belongs_to_many :quizzes, foreign_key: "question_id"
  belongs_to :school

  serialize :data, Hash
  def self.data_accessor(*names)
    include Module.new {
      names.each do |name|
        define_method(name) do
          self.data[name] rescue nil
        end

        define_method("#{name}=") do |value|
          self.data = (data || {}).merge(name => value)
        end
      end
    }
  end

  default_scope -> { order("updated_at DESC") }

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
    self.class.name.underscore.chomp("_question")
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
