# encoding: utf-8
require_relative "../../lib/has_many_questions"

class Quiz < ActiveRecord::Base
  attr_accessible :name, :grades, :activated

  belongs_to :school
  extend HasManyQuestions
  has_many_questions dependent: :destroy
  has_many :games

  serialize :grades, Array

  validates_presence_of :name, :school_id

  default_scope order("#{table_name}.created_at DESC")
  scope :activated, where(activated: true)

  def grades=(array)
    write_attribute(:grades, array.reject(&:blank?).map(&:to_i))
  end

  def to_s
    name
  end
end
