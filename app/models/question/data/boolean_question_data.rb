require "active_record"

class BooleanQuestionData < ActiveRecord::Base
  attr_accessible :answer

  validates_inclusion_of :answer, in: [true, false]
end
