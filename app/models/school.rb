# encoding: utf-8

class School < ActiveRecord::Base
  has_many :students
  has_many :quizzes
  has_many :questions, through: :quizzes

  has_secure_password

  validates_presence_of :name, :level, :username, :password, :key
  validates_uniqueness_of :username

  def to_s
    name
  end

  def grades
    primary? ? (1..8) : (1..4)
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
    find_by_username(credentials[:username]).try(:authenticate, credentials[:password])
  end
end
