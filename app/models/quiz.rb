# encoding: utf-8
require "active_record"
require_relative "../../lib/has_many_questions"

class Quiz < ActiveRecord::Base
  attr_accessible :name, :grades, :activated

  belongs_to :school
  extend HasManyQuestions
  has_many_questions dependent: :destroy
  has_many :games

  serialize :grades, Array

  validates_presence_of :name, :school_id
  validate :validate_questions, if: :activated

  default_scope order("#{table_name}.created_at DESC")
  scope :activated, where(activated: true)

  def grades=(array)
    write_attribute(:grades, array.reject(&:blank?).map(&:to_i))
  end

  def to_s
    name
  end

  private

  def validate_questions
    if questions.count < 2
      errors[:base] << "Kviz mora imati barem 2 pitanja prije nego što se može aktivirati."
    elsif not questions.group_by(&:category).values.map(&:count).all?(&:even?)
      errors[:base] << "Kviz mora imati paran broj svakog tipa pitanja prije nego što se može aktivirati."
    end
  end
end
