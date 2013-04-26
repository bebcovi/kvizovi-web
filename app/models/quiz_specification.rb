require "active_attr"

class QuizSpecification
  include ActiveAttr::Model

  attribute :quiz_id
  attribute :students_count, type: Integer
  attribute :students_credentials, default: []

  validates :quiz_id,        presence: true
  validates :students_count, presence: true
  validate :validate_authenticity_of_students

  attr_writer :students
  def students
    @students ||= []
  end

  def quiz
    @quiz ||= Quiz.find(quiz_id) if quiz_id
  end

  def to_h
    question_ids = quiz.question_ids
    question_ids.shuffle! if quiz.shuffle_questions?
    student_ids = students.map(&:id)
    question_ids.pop until question_ids.count % student_ids.count == 0

    {
      quiz_id:      quiz_id,
      question_ids: question_ids,
      student_ids:  student_ids,
    }
  end

  private

  def validate_authenticity_of_students
    self.students += students_credentials
      .map { |attr| authenticate(attr[:username], attr[:password]) }
      .reject(&:blank?)

    if students_count && students_count != students.count
      errors.add(:students_credentials, :invalid)
    end
  end

  def authenticate(*args)
    UserAuthenticator.new(Student).authenticate(*args)
  end
end
