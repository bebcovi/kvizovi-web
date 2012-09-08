# encoding: utf-8

class Student < ActiveRecord::Base
  attr_accessor :school_key
  belongs_to :school

  has_secure_password

  validate :validate_school_key, on: :create
  validates_presence_of :password, on: :create
  validates :username, presence: true, uniqueness: true
  validates_format_of :username, with: /^[a-zA-Z0-9_]{3,}$/, message: "Može sadržavati samo (engleska) slova, brojeve i '_'"
  validates_presence_of :first_name, :last_name, :grade

  before_create do
    self.school = School.find_by_key(school_key)
  end

  def increase_score!(points)
    update_attribute(:score, score + points)
    self
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def to_s
    full_name
  end

  def self.authenticate(credentials)
    find_by_username(credentials[:username]).try(:authenticate, credentials[:password])
  end

  private

  def validate_school_key
    unless School.find_by_key(school_key)
      errors[:school_key] << "Ne postoji škola s tim ključem."
    end
  end
end
