class Quiz < ActiveRecord::Base
  attr_accessible :name, :password

  belongs_to :school
  has_many :questions
end
