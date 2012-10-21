# encoding: utf-8
require "active_record"
require_relative "../../lib/has_many_questions"
require "activerecord-postgres-hstore"

class Quiz < ActiveRecord::Base
  belongs_to :school
  extend HasManyQuestions
  has_many_questions dependent: :destroy
  has_many :games

  serialize :grades, ActiveRecord::Coders::Hstore

  validates_presence_of :name, :school_id
  validate :validate_questions, if: :activated

  default_scope order("#{table_name}.created_at DESC")
  scope :activated, where(activated: true)

  def grades=(array)
    grades = array.reject(&:blank?).map(&:to_i)
    hash = {}
    if grades.any?
      (1..8).each { |grade| hash[grade.to_s] = grades.include?(grade).to_s }
    else
      (1..8).each { |grade| hash[grade.to_s] = "true" }
    end

    write_attribute(:grades, hash)
  end

  def grades
    (read_attribute(:grades) || {}).
      select { |grade, presence| presence == "true" }.
      keys.map(&:to_i)
  end

  def to_s
    name
  end

  private

  def validate_questions
    if questions.count < 2
      errors[:base] << "Kviz mora imati barem 2 pitanja prije nego što se može aktivirati."
    elsif not questions.group_by(&:category).values.map(&:count).all?(&:even?)
      errors[:base] << "Kviz mora imati paran broj (može i 0) svakog tipa pitanja prije nego što se može aktivirati."
    end
  end
end
