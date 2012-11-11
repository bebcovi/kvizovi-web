# encoding: utf-8
require "active_record"
require_relative "../../lib/has_many_questions"
require "activerecord-postgres-hstore"

class Quiz < ActiveRecord::Base
  belongs_to :school
  extend HasManyQuestions
  has_and_belongs_to_many_questions association_foreign_key: "question_id"
  has_many :games

  serialize :grades, ActiveRecord::Coders::Hstore

  validates_presence_of :name, :school_id

  default_scope order("#{table_name}.created_at DESC")
  scope :activated, where(activated: true)
  scope :with_intended_grade, ->(grade) { where("grades -> '#{grade.to_i}' = 'true'") }

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
end
