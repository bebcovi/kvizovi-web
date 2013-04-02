class Question < ActiveRecord::Base
  CATEGORIES = %w[boolean choice association image text]

  has_and_belongs_to_many :quizzes, foreign_key: "question_id"
  belongs_to :school

  acts_as_taggable

  scope :search, ->(query) { scoped }

  validates :content, presence: true

  def self.data_value(name)
    class_eval <<-RUBY, __FILE__, __LINE__ + 1
      alias old_#{name} #{name}
      def #{name}
        @#{name} ||= #{name.to_s.camelize}.new(old_#{name})
      end

      alias old_#{name}= #{name}=
      def #{name}=(value)
        self.old_#{name} = value
        @#{name} = nil
      end
    RUBY
  end

  def dup
    super.tap do |question|
      question.tag_list = self.tag_list
    end
  end

  def randomize!
    self
  end
end
