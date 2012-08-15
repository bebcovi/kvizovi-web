class School < ActiveRecord::Base
  attr_accessible :full_name, :key, :level, :username, :password
  has_secure_password

  has_many :students
  has_many :quizzes
  has_many :questions, through: :quizzes

  validates_presence_of :full_name, :key, :level, :username, :password

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
    find_by_username(credentials[:username]).try(:authenticate, credentials[:password]) || false
  end
end
