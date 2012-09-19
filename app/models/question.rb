# encoding: utf-8

class Question < ActiveRecord::Base
  belongs_to :quiz

  serialize :data
  has_attached_file :attachment, styles: {medium: "x250>"}

  validates_presence_of :content
  validates :attachment, attachment_presence: true, if: proc { photo? }
  validate :validate_provided_answers, if: proc { choice? or association? }
  validates_presence_of :data, message: "Niste odabrali točan odgovor.", if: proc { boolean? }
  validates_presence_of :data, message: "Niste napisali točan odgovor.", unless: proc { boolean? }

  %w[boolean choice association photo text].each do |category|
    define_method("#{category}?") do
      self.category == category
    end
  end

  def to_s
    content
  end

  def provided_answers
    if association?
      unless data.nil?
        left_column = data.values_at(*data.each_index.select(&:even?))
        right_column = data.values_at(*data.each_index.select(&:odd?))
        left_column.zip(right_column)
      else
        {}
      end
    elsif choice?
      data || []
    else
      data
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
    if photo? or text?
      answer.chomp(".").casecmp(self.answer) == 0
    else
      answer == self.answer
    end
  end

  private

  def validate_provided_answers
    if data.any?(&:blank?)
      data.each_with_index do |text, index|
        errors.add(:"question_data_#{index + 1}", "Ne smije biti prazno.") if text.blank?
      end
    end
  end
end
