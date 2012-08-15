class Student < ActiveRecord::Base
  attr_accessible :grade, :first_name, :last_name, :username, :password
  attr_accessor :score
  has_secure_password

  belongs_to :school

  validates_presence_of :grade, :first_name, :last_name, :username, :password
  validates_uniqueness_of :username

  def name
    "#{first_name} #{last_name}"
  end

  def self.authenticate(credentials)
    find_by_username(credentials[:username]).try(:authenticate, credentials[:password]) || false
  end
end
