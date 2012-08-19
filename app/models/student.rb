# encoding: utf-8

class Student < ActiveRecord::Base
  belongs_to :school

  has_secure_password

  validate :username_must_me_unique

  def full_name
    "#{first_name} #{last_name}"
  end

  def to_s
    full_name
  end

  def self.authenticate(credentials)
    find_by_username(credentials[:username]).try(:authenticate, credentials[:password])
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

  private

  def username_must_me_unique
    if [self.class, School].any? { |model| model.find_by_username(username) }
      errors.add(:username, "je već zauzeto.")
    end
  end
end
