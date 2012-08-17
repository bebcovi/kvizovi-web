class Quiz < ActiveRecord::Base
  belongs_to :school
  has_many :questions
end
