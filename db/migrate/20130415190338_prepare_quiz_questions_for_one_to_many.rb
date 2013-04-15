class PrepareQuizQuestionsForOneToMany < ActiveRecord::Migration
  class Question < ActiveRecord::Base
    has_and_belongs_to_many :quizzes

    acts_as_taggable

    def dup
      super.tap do |question|
        question.tag_list = self.tag_list
      end
    end
  end

  class Quiz < ActiveRecord::Base
    has_many :questions
  end

  def up
    Question.find_each do |question|
      if question.quizzes.count >= 1
        if question.quizzes.count > 1
          question.quizzes[1..-1].each do |quiz|
            quiz.questions << question.dup
          end
        end

        question.update_column(:quiz_id, question.quizzes[0].id)
      else
        if column_exists?(:questions, :school_id)
          quiz = Quiz.find_or_create_by_name(name: "Pitanja bez kviza", activated: false, school_id: question.school_id)
          question.update_column(:quiz_id, quiz.id)
        else
          question.destroy
        end
      end
    end
  end

  def down
  end
end
