class AddPlayCountToQuizzes < ActiveRecord::Migration
  class Quiz < ActiveRecord::Base
  end

  class QuizSnapshot < ActiveRecord::Base
  end

  def change
    add_column :quizzes, :play_count, :integer

    reversible do |direction|
      direction.up do
        Quiz.find_each do |quiz|
          quiz.update(play_count: QuizSnapshot.where(quiz_id: quiz.id).count)
        end
      end
    end
  end
end
