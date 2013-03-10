class Student < ActiveRecord::Base
  belongs_to :school

  has_secure_password
  attr_accessor :school_key

  validates :username, presence: true, format: {with: /\A[a-zA-Z0-9_]*\Z/}, length: {minimum: 3}, uniqueness: true
  validates :password, presence: true
  validates :grade, presence: true, format: {with: /\A[0-8][a-z]\Z$/}
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :gender, presence: true
  validates :year_of_birth, presence: true, numericality: {only_integer: true}

  validate :validate_school_key, unless: :school_id?

  before_create { self.school ||= School.find_by_key(school_key) }

  def full_name; "#{first_name} #{last_name}"; end

  def to_s; full_name; end

  def male?;   gender == "Muško"; end
  def female?; gender == "Žensko"; end

  def grade=(value)
    write_attribute(:grade, value.to_s.delete(" .").downcase)
  end

  def games
    Game.where("games.first_player_id = #{id} OR games.second_player_id = #{id}")
  end

  def self.authenticate(credentials)
    find_by_username(credentials[:username]).try(:authenticate, credentials[:password])
  end

  def available_quizzes
    school.quizzes.activated.for_student(self)
  end

  private

  def validate_school_key
    unless School.find_by_key(school_key)
      errors[:school_key] << "Ne postoji škola s tim ključem."
    end
  end
end
