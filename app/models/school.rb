class School < ActiveRecord::Base
  has_many :students
  has_many :quizzes
  has_many :questions, through: :quizzes
  has_many :books
  has_many :eras

  has_secure_password
  extend FriendlyId
  friendly_id :username, use: :slugged

  validates_uniqueness_of :name

  def to_s
    name
  end

  def primary?
    level == 1
  end

  def secondary?
    level == 2
  end

  LEVELS = {
    1 => "Osnovna",
    2 => "Srednja"
  }

  def self.authenticate(credentials)
    find_by_username(credentials[:username]).try(:authenticate, credentials[:password]) or false
  end
end
