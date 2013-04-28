require "squeel"

class Student < ActiveRecord::Base
  GENDERS = ["Muško", "Žensko"]

  belongs_to :school
  def played_quizzes; PlayedQuiz.where{student_ids =~ "% #{my{id}} %"}; end

  has_secure_password
  attr_accessor :school_key

  validates :username,      presence: true, format: {with: /\A[a-zA-Z0-9_]*\Z/, allow_blank: true}, length: {minimum: 3, allow_blank: true}, uniqueness: true
  validates :password,      presence: true, on: :create
  validates :grade,         presence: true, format: {with: /\A[0-8][a-z]\Z$/, allow_blank: true}
  validates :first_name,    presence: true
  validates :last_name,     presence: true
  validates :gender,        presence: true, inclusion: {in: GENDERS, allow_blank: true}
  validates :year_of_birth, presence: true, numericality: {only_integer: true, allow_blank: true}
  validates :school_key,    presence: true, inclusion: {in: proc { School.pluck(:key) }, allow_blank: true}, unless: :school_id?

  before_create :assign_school, unless: :school_id?

  def type; "student"; end

  def to_s; full_name; end
  def full_name; "#{first_name} #{last_name}"; end

  def male?;   gender == "Muško"; end
  def female?; gender == "Žensko"; end

  def grade=(value)
    write_attribute(:grade, value.to_s.delete(" .").downcase)
  end

  private

  def assign_school
    self.school ||= School.find_by_key(school_key)
  end
end
