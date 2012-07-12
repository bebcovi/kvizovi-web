class Question < ActiveRecord::Base
  attr_accessible :content, :correct_answer, :points, :type
  attr_accessor :answer

  belongs_to :quiz
  belongs_to :book
  has_many :answers

  TYPES = {
    1 => :boolean,
    2 => :choice,
    3 => :association,
    4 => :photo,
    5 => :text
  }
end
