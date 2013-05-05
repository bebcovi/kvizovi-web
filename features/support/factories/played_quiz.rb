FactoryGirl.define do
  factory :played_quiz do
    begin_time 3.minutes.ago
    end_time Time.now

    before(:create) do |played_quiz|
      categories = Hash.new(0)
      played_quiz.question_answers = played_quiz.questions.map do |question|
        case question
        when BooleanQuestion
          wrong_answer = !question.answer
        when AssociationQuestion
          wrong_answer = question.answer.map(&:first).zip(question.answer.map(&:last).reverse)
        when ChoiceQuestion
          wrong_answer = question.provided_answers[1..-1].sample
        when ImageQuestion, TextQuestion
          wrong_answer = question.answer.reverse
        end
        answer = [wrong_answer, question.answer, Question::NO_ANSWER, nil][categories[question.category]]
        categories[question.category] += 1
        answer
      end
    end
  end
end if $load_factories
