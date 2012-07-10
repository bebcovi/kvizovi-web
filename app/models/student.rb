class Student < ActiveRecord::Base
  attr_accessible :class, :first_name, :last_name, :password, :username

  belongs_to :school
end
