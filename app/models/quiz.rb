require "squeel"

class Quiz < ActiveRecord::Base
  belongs_to :school
  has_many :questions, dependent: :destroy
  has_many :snapshots, class_name: "QuizSnapshot"
  has_many :played_quizzes, through: :snapshots

  validates :name,      presence: true, uniqueness: {scope: :school_id}
  validates :school_id, presence: true

  scope :activated,       -> { where{activated == true} }
  scope :descending,      -> { order{created_at.desc} }
  scope :order_by_school, -> { order{school.name.asc} }

  accepts_nested_attributes_for :questions

  def to_s
    name
  end
end
