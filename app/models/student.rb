class Student < ActiveRecord::Base
  attr_accessible :class, :first_name, :last_name, :username, :password

  belongs_to :school

  validates_presence_of :class, :first_name, :last_name, :username, :password
end
