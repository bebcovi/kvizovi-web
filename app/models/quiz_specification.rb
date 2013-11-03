require "active_attr"

class QuizSpecification
  include ActiveAttr::Model

  attribute :quiz_id
  attribute :students_count, type: Integer
  attribute :students_credentials, default: []

  validates :quiz_id,        presence: true
  validates :students_count, presence: true
  validate :validate_authenticity_of_students

  def students
    @students ||= []
  end

  def quiz
    @quiz ||= Quiz.find(quiz_id) if quiz_id
  end

  private

  def validate_authenticity_of_students
    students_credentials
      .map { |attributes| authenticate(attributes) }
      .reject(&:blank?)
      .each { |student| students << student }

    if students_count && students_count != students.count
      errors.add(:students_credentials, :invalid)
    end
  end

  def authenticate(attrs)
    student = Student.find_by(username: attrs[:username])
    student.try(:authenticate, attrs[:password])
  end
end
