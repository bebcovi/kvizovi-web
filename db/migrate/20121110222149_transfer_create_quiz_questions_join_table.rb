class TransferCreateQuizQuestionsJoinTable < ActiveRecord::Migration
  class Question         < ActiveRecord::Base; end
  class Quiz             < ActiveRecord::Base; end
  class QuestionsQuizzes < ActiveRecord::Base; end

  def up
    Question.find_each do |question|
      QuestionsQuizzes.create(question_id: question.id, quiz_id: question.quiz_id)
      question.update_attributes(school_id: Quiz.find(question.quiz_id).school_id)
    end
  end

  def down
    Question.find_each do |question|
      QuestionsQuizzes.where(question_id: question.id).each_with_index do |data, index|
        if index == 0
          question.update_attributes(quiz_id: data.quiz_id)
        else
          duplicate_question = question.dup
          duplicate_question.assign_attributes(quiz_id: data.quiz_id)
          duplicate_question.save
        end
      end
    end
    question_ids_with_quiz = QuestionsQuizzes.uniq.pluck(:question_id).join(",")
    Question.where("id NOT IN (#{question_ids_with_quiz})").each do |question|
      quiz = Quiz.where(name: "Pitanja bez kviza", school_id: question.school_id).first_or_create
      question.update_attributes(quiz_id: quiz.id)
    end
  end
end
