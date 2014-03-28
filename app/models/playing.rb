require "acts_as_list"

class Playing < ActiveRecord::Base
  belongs_to :player, class_name: "Student"
  belongs_to :played_quiz

  acts_as_list scope: :played_quiz
end
