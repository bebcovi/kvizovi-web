class CopyNewGrades < ActiveRecord::Migration
  class Quiz < ActiveRecord::Base
  end

  def up
    Quiz.all.each do |quiz|
      quiz.update_attributes(new_grades: quiz.grades || [])
    end
  end

  def down
    Quiz.all.each do |quiz|
      quiz.update_attributes(grades: quiz.new_grades || [])
    end
  end
end
