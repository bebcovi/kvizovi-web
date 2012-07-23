class School < ActiveRecord::Base
  attr_accessible :full_name, :key, :level, :username, :password

  has_many :students
  has_many :quizzes

  validates_presence_of :full_name, :key, :level, :username, :password
end
