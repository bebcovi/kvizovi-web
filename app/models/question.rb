require "active_record"
require "activerecord-postgres-hstore"
require "acts-as-taggable-on"

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
  acts_as_taggable

  default_scope -> { order("updated_at DESC") }
  scope :not_owned_by, ->(school) { where("school_id <> #{school.id}") }
  scope :filter, ->(filter) { tagged_with(filter[:tags]) }

  validates_presence_of :content

  def self.categories
    %w[boolean choice association image text]
  end

  categories.each do |category|
    define_method("#{category}?") do
      self.category == category
    end
  end

  alias normal_cased_tag_list tag_list
  def tag_list
    normal_cased_tag_list.map(&:downcase).join(", ")
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
