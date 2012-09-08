# encoding: utf-8

class Question < ActiveRecord::Base
  belongs_to :quiz

  serialize :data
  has_attached_file :attachment, styles: {medium: "x250"}

  validates_presence_of :content, :points
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
        half = data.count / 2
        Hash[data.first(half).zip(data.last(half))]
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
      answer.casecmp(self.answer) == 0
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
