class Student < ActiveRecord::Base
  belongs_to :school
  def games; Game.where("games.first_player_id = #{id} OR games.second_player_id = #{id}"); end
  def available_quizzes; school.quizzes.activated.for_student(self); end

  has_secure_password
  attr_accessor :school_key

  validates :username, presence: true, format: {with: /\A[a-zA-Z0-9_]*\Z/}, length: {minimum: 3}, uniqueness: true
  validates :password, presence: true, on: :create
  validates :grade, presence: true, format: {with: /\A[0-8][a-z]\Z$/}
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :gender, presence: true
  validates :year_of_birth, presence: true, numericality: {only_integer: true}
  validates :school_key, presence: true, inclusion: {in: proc { School.pluck(:key) }}, unless: :school_id?

  before_create :assign_school

  def full_name; "#{first_name} #{last_name}"; end

  def to_s; full_name; end

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
