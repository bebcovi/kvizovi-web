# encoding: utf-8
require "active_record"
require_relative "../../lib/has_many_questions"

class Quiz < ActiveRecord::Base
  belongs_to :school
  extend HasManyQuestions
  has_and_belongs_to_many_questions association_foreign_key: "question_id"
  has_many :games

  validates_presence_of :name, :school_id

  default_scope order("#{table_name}.created_at DESC")
  scope :activated, where(activated: true)
  scope :for_student, ->(student) { where("? = ANY(grades)", student.grade) }

  def grades=(array)
    write_attribute(:grades, array.reject(&:blank?))
  end

  def to_s
    name
  end
end
