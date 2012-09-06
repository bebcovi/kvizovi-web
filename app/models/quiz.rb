class Quiz < ActiveRecord::Base
  belongs_to :school
  has_many :questions, dependent: :destroy
  has_many :games

  serialize :grades, Array

  scope :activated, where(activated: true)

  def grades=(array)
    write_attribute(:grades, array.reject(&:blank?).map(&:to_i))
  end

  def to_s
    name
  end
end
