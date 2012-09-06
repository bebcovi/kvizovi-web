class Question < ActiveRecord::Base
  belongs_to :quiz

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
      half = data.count / 2
      Hash[data.first(half).zip(data.last(half))]
    end
  end

  def answer
    if choice?
      data.first
    else
      data
    end
  end

  def correct_answer?(answer)
    answer.to_s == self.answer.to_s
  end
end
