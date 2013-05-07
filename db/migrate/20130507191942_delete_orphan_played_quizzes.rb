class DeleteOrphanPlayedQuizzes < ActiveRecord::Migration
  class Student < ActiveRecord::Base
  end

  class PlayedQuiz < ActiveRecord::Base
    serialize :students_order
    belongs_to :quiz_snapshot, dependent: :destroy
  end

  class QuizSnapshot < ActiveRecord::Base
  end

  class Quiz < ActiveRecord::Base
  end

  def up
    PlayedQuiz.find_each do |played_quiz|
      begin
        Student.find(played_quiz.students_order)
        Quiz.find(played_quiz.quiz_snapshot.quiz_id)
      rescue ActiveRecord::RecordNotFound
        played_quiz.destroy
      end
    end
  end

  def down
  end
end
