class ProgressPresenter < BasePresenter
  def initialize(*args)
    @question_number, @questions_count = args
  end

  def number_of_answered_questions
    @question_number - 1
  end

  def number_of_questions_to_be_answered
    @questions_count - number_of_answered_questions
  end

  def chunk_size
    100 / @questions_count.to_f
  end
end
