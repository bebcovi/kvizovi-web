class Question < ActiveRecord::Base
  belongs_to :quiz, dependent: :destroy

  serialize :data
  has_attached_file :attachment, styles: {medium: "300x300"}

  before_save :transform_data, if: proc { data.is_a?(Hash) }

  CATEGORIES = {
    1 => :boolean,
    2 => :choice,
    3 => :association,
    4 => :photo,
    5 => :text
  }

  CATEGORIES.values.each do |category|
    define_method("#{category}?") do
      CATEGORIES[self.category] == category
    end
  end

  def category_text
    CATEGORIES[category]
  end

  def to_s
    content
  end

  def provided_answers
    case
    when boolean?
      # Nothing
    when choice?
      data
    when association?
      data
    when photo?
      # Nothing
    when text?
      # Nothing
    end
  end

  def answer
    case
    when boolean?
      data
    when choice?
      data.first
    when association?
      data
    when photo?
      data
    when text?
      data
    end
  end

  def correct_answer?(answer)
    case
    when association?
      n = answer.count / 2
      answer = Hash[answer.first(n).zip(answer.last(n))]
    end

    answer == self.answer
  end

  private

  def transform_data
    case
    when boolean?
      self.data = data[:boolean]
    when choice?
      self.data = data[:choice]
    when association?
      n = data[:association].count / 2
      left_column, right_column = data[:association].first(n), data[:association].last(n)
      self.data = Hash[left_column.zip(right_column)]
    when photo?
      self.data = data[:photo]
    when text?
      self.data = data[:text]
    end
  end
end
