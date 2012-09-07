# encoding: utf-8

class Question < ActiveRecord::Base
  belongs_to :quiz

  serialize :data
  has_attached_file :attachment, styles: {medium: "300x300"}

  validate :validate

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
    if photo? or text?
      answer.casecmp(self.answer) == 0
    else
      answer == self.answer
    end
  end

  private

  def validate
    if content.blank?
      errors.add(:base, "Niste napisali tekst pitanja.")
    end

    case
    when boolean?
      if data.blank?
        errors.add(:base, "Morate specificirati da li je tvrdnja točna ili netočna.")
      end
    when (choice? or association?)
      if data.any?(&:blank?)
        data.each_with_index do |text, index|
          errors.add(:"question_data_#{index + 1}", "Ne smije biti prazno.") if text.blank?
        end
      end
    when photo?
      if send(:read_attribute_for_validation, "attachment_file_name").blank?
        errors.add(:base, "Niste odabrali sliku.")
      end
      if data.blank?
        errors.add(:base, "Niste napisali točan odgovor.")
      end
    when text?
      if data.blank?
        errors.add(:base, "Niste napisali točan odgovor.")
      end
    end

    if points.blank?
      errors.add(:base, "Niste odredili koliko pitanje nosi bodova.")
    end
  end
end
