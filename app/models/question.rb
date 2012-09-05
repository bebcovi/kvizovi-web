class Question < ActiveRecord::Base
  belongs_to :quiz, dependent: :destroy

  serialize :data
  has_attached_file :attachment, styles: {medium: "300x300"}

  %w[boolean choice association photo text].each do |category|
    define_method("#{category}?") do
      self.category == category
    end
  end

  def to_s
    content
  end

  def provided_answers
    return [] if data.nil?

    if choice?
      data
    elsif association?
      n = data.count / 2
      Hash[data.first(n).zip(data.last(n))]
    end
  end

  def answer
    case
    when choice?
      data.first
    else
      data
    end
  end

  def correct_answer?(answer)
    answer == self.answer
  end
end
