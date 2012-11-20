# encoding: utf-8
require "active_record"

class Student < ActiveRecord::Base
  attr_accessor :school_key

  belongs_to :school

  has_secure_password

  validate :validate_school_key, unless: :school_id?
  validates_format_of :username, with: /^[a-zA-Z0-9_]*$/
  validates_format_of :grade, with: /^[0-8][a-z]$/, allow_blank: true
  validates_length_of :username, minimum: 3
  validates_presence_of :first_name, :last_name, :username, :password, :gender, :grade, :year_of_birth
  validates_uniqueness_of :username

  before_create { self.school ||= School.find_by_key(school_key) }

  def grade=(value)
    write_attribute(:grade, value.to_s.delete(" .").downcase)
  end

  def games
    Game.where("games.first_player_id = #{id} or games.second_player_id = #{id}")
  end

  def available_quizzes
    school.quizzes.activated.for_student(self)
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
