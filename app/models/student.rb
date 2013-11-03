require "squeel"

class Student < ActiveRecord::Base
  belongs_to :school
  has_and_belongs_to_many :played_quizzes
  has_many :readings, as: :user, dependent: :destroy
  has_many :read_posts, through: :readings, source: :post

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  attr_accessor :school_key

  validates :username,      presence: true, format: {with: /\A[a-zA-Z0-9_]*\Z/, allow_blank: true}, length: {minimum: 3, allow_blank: true}, uniqueness: true
  validates :grade,         presence: true, format: {with: /\A[0-8][a-z]\Z/, allow_blank: true}
  validates :first_name,    presence: true
  validates :last_name,     presence: true
  validates :gender,        presence: true
  validates :year_of_birth, presence: true, numericality: {only_integer: true, allow_blank: true}
  validates :school_key,    presence: true, inclusion: {in: proc { School.pluck(:key) }, allow_blank: true}, unless: :school_id?

  before_create :assign_school, unless: :school_id?
  before_destroy :destroy_played_quizzes

  def type; "student"; end

  def to_s; full_name; end
  def full_name; "#{first_name} #{last_name}"; end

  def male?;   gender == "Muško"; end
  def female?; gender == "Žensko"; end

  def grade=(value)
    write_attribute(:grade, value.to_s.delete(" .").downcase)
  end

  def last_activity
    LastActivity.for(self).read
  end

  def unread_posts
    Post.not_in(read_posts)
  end

  def admin?
    false
  end

  def authenticate(password)
    BCrypt::Password.new(encrypted_password) == password && self
  end

  private

  def assign_school
    self.school ||= School.find_by_key(school_key)
  end

  def destroy_played_quizzes
    played_quizzes.destroy_all
  end
end
