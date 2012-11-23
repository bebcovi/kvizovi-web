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

  default_scope            ->         { order("#{table_name}.updated_at DESC") }
  scope :not_owned_by,     ->(school) { where("#{table_name}.school_id <> #{school.id}") }
  scope :not_belonging_to, ->(quiz)   { includes(:quizzes).where("quizzes.id IS NULL OR quizzes.id <> #{quiz.id}") }
  scope :public,           ->         { joins(:school).where("schools.public_questions = 't'") }
  scope :without_example,  ->         { includes(:quizzes).where("quizzes.id IS NULL OR quizzes.name <> 'Antigona'") }
  scope :filter,           ->(filter) { tagged_with(filter[:tags]) }

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

  def dup
    super.tap do |question|
      question.tag_list = self.tag_list
    end
  end
  alias duplicate dup

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
