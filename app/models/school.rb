class School < ActiveRecord::Base
  attr_accessible :full_name, :key, :password, :kind, :username

  has_many :students
  has_many :quizzes
end
