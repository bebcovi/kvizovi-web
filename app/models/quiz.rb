class Quiz < ActiveRecord::Base
  attr_accessible :name, :grade

  belongs_to :school
  has_many :questions
end
