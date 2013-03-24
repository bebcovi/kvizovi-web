require_relative "../../lib/has_many_questions"

class Quiz < ActiveRecord::Base
  belongs_to :school
  extend HasManyQuestions
  has_and_belongs_to_many_questions association_foreign_key: "question_id"
  has_many :games

  validates :name,      presence: true
  validates :school_id, presence: true

  default_scope       -> { order{created_at.desc} }
  scope :activated,   -> { where{activated == true} }

  def to_s
    name
  end
end
