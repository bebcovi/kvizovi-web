class Quiz < ActiveRecord::Base
  belongs_to :school
  has_many :questions, dependent: :destroy
  has_many :games

  validates :name,      presence: true
  validates :school_id, presence: true

  default_scope     -> { order{created_at.desc} }
  scope :activated, -> { where{activated == true} }

  def to_s
    name
  end
end
