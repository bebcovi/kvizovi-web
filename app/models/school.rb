# encoding: utf-8

class School < ActiveRecord::Base
  has_many :students
  has_many :quizzes, dependent: :destroy
  has_many :questions, through: :quizzes

  has_secure_password

  validates_presence_of :name, :level, :username, :key, :place, :region
  validates_presence_of :password, on: :create
  validates_uniqueness_of :username

  def to_s
    name
  end

  def grades
    primary? ? (1..8) : (1..4)
  end

  def primary?
    level == "Osnovna"
  end

  def secondary?
    level == "Srednja"
  end

  def self.authenticate(credentials)
    find_by_username(credentials[:username]).try(:authenticate, credentials[:password])
  end
end
