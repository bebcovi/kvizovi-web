class CopyGradesOnQuizzes < ActiveRecord::Migration
  class Quiz < ActiveRecord::Base
    serialize :grades, ActiveRecord::Coders::Hstore
  end

  def up
    Quiz.all.each do |quiz|
      quiz.grades_array = quiz.grades.select { |_, present| present == "true" }.keys.map { |grade| Array("#{grade}a".."#{grade}l") }.flatten
      quiz.save
    end
  end

  def down
    Quiz.all.each do |quiz|
      hash = {}
      intended_grades = quiz.grades_array.map { |grade| grade.to_i }.uniq
      quiz.grades = (1..8).inject({}) do |hash, grade|
        hash.update(grade => intended_grades.include?(grade))
      end
      quiz.save
    end
  end
end
