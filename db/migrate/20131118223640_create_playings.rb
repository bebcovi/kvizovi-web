class CreatePlayings < ActiveRecord::Migration
  class PlayedQuiz < ActiveRecord::Base
    has_and_belongs_to_many :students

    serialize :students_order, Array
  end

  class Student < ActiveRecord::Base
  end

  class Playing < ActiveRecord::Base
    belongs_to :student
    belongs_to :played_quiz
  end

  def change
    rename_table :played_quizzes_students, :playings
    change_table :playings do |t|
      t.integer :position
    end

    if column_exists?(:playings, :student_id)
      PlayedQuiz.find_each do |played_quiz|
        playing = Playing.where(played_quiz_id: played_quiz.id)
        played_quiz.students_order.each_with_index do |student_id, idx|
          playing.where(student_id: student_id).update_all(position: idx + 1)
        end
      end
    end

    remove_column :played_quizzes, :students_order, :string

    change_table :playings do |t|
      t.rename :student_id, :player_id
    end
  end
end
