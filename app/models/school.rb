# encoding: utf-8

class School < ActiveRecord::Base
  has_many :students
  has_many :quizzes
  has_many :questions, through: :quizzes
  has_many :books
  has_many :eras

  has_secure_password
  extend FriendlyId
  friendly_id :username, use: :slugged

  validate :username_must_me_unique

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
    find_by_username(credentials[:username]).try(:authenticate, credentials[:password])
  end

  private

  def username_must_me_unique
    if [self.class, Student].any? { |model| model.find_by_username(username) }
      errors.add(:username, "je već zauzeto.")
    end
  end
end
