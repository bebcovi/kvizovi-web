class Quiz < ActiveRecord::Base
  belongs_to :school
  has_many :questions
  has_many :games

  serialize :grades, Array

  scope :activated, where(activated: true)
end
