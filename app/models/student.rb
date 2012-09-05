# encoding: utf-8

class Student < ActiveRecord::Base
  attr_accessor :school_key
  belongs_to :school

  has_secure_password

  before_validation on: :create do
    self.school = School.find_by_key(school_key)
  end

  validates_uniqueness_of :username
  validates_presence_of :school, on: :create

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

  def self.create_with_school_key(params)
    if school = School.find_by_key(params[:school][:key])
      school.students.create(params.except(:school))
    else
      Student.new(params) do |student|
        student.errors[:base] << "Ne postoji škola s tim ključem."
      end
    end
  end
end
