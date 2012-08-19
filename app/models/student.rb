# encoding: utf-8

class Student < ActiveRecord::Base
  belongs_to :school

  has_secure_password

  validates_uniqueness_of :username

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
      school.students.create(params)
    else
      Student.new(params) do |student|
        student.errors[:base] << "Ne postoji škola s tim ključem."
      end
    end
  end
end
