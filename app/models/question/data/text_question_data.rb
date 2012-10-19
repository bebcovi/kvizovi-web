require "active_record"

class TextQuestionData < ActiveRecord::Base
  attr_accessible :answer

  validates_presence_of :answer
end
