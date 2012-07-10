class Question < ActiveRecord::Base
  attr_accessible :content, :correct_answer, :points, :type

  belongs_to :quiz
  belongs_to :book
  has_many :asnwers
end
