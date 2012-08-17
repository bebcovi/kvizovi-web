class School < ActiveRecord::Base
  attr_accessible :name, :key, :level, :username, :password

  has_many :students
  has_many :quizzes
  has_many :questions, through: :quizzes

  has_secure_password
  extend FriendlyId
  friendly_id :name, use: :slugged

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
