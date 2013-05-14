class SurveyField < ActiveRecord::Base
  serialize :choices
  serialize :answer

  attr_accessor :required

  validates :question, presence: true
  validate :validate_presence_of_answer, if: :required

  def choices=(value)
    write_attribute(:choices, value.split("@"))
  end

  def answer=(value)
    value.reject!(&:blank?) if value.is_a?(Array)
    value = value.values if value.is_a?(Hash)
    write_attribute(:answer, value)
  end

  private

  def validate_presence_of_answer
    if answer.blank? or (Array(answer).first.is_a?(Hash) and answer.any? { |hash| hash[:answer].blank? })
      errors.add(:answer, :blank)
    end
  end
end
