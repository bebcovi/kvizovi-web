# encoding: utf-8

class Student < ActiveRecord::Base
  belongs_to :school

  has_secure_password

  def full_name
    "#{first_name} #{last_name}"
  end

  def to_s
    full_name
  end

  def self.authenticate(credentials)
    find_by_username(credentials[:username]).try(:authenticate, credentials[:password]) or false
  end

  def self.create_with_key(params, key)
    if school = School.find_by_key(key)
      school.students.create(params)
    else
      Student.new(params).tap do |student|
        student.errors[:base] << "Ne postoji škola s tim ključem."
      end
    end
  end
end
