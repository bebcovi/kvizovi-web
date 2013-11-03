require "factory_girl"

FactoryGirl.define do
  factory :school do
    name     "MIOC"
    level    "Srednja"
    sequence(:username) { |n| "mioc#{n}" }
    password "mioc"
    password_confirmation "mioc"
    sequence(:email) { |n| "mioc#{n}@skola.hr" }
    key      "mioc"
    place    "Zagreb"
    region   "Grad Zagreb"
  end

  School.skip_callback(:create, :after, :create_example_quizzes)

  factory :student do
    first_name "Jon"
    last_name "Snow"
    grade "2d"
    gender "Muško"
    year_of_birth 1991
    sequence(:username) { |n| "jon#{n}" }
    password "wildlings"
    password_confirmation "wildlings"
    sequence(:email) { |n| "jon.snow#{n}@example.com" }
    school_id 1
  end

  factory :quiz do
    name "Some quiz"
    activated true
  end

  factory :boolean_question, aliases: [:question] do
    content "Stannis Baratheon won the war against King's Landing."
    answer false
  end

  factory :choice_question do
    content "Eliminate the bastard."
    provided_answers ["Jon Snow", "Robb Stark", "Bran Stark", "Ned Stark"]
  end

  factory :association_question do
    content "Connect Game of Thrones characters:"
    associations({
      "Sansa Stark"      => %("...but I don't want anyone smart, brave or good looking, I want Joffrey!"),
      "Tywin Lannister"  => %("Attacking Ned Stark in the middle of King Landing was stupid. Lannisters don't do stupid things."),
      "Tyrion Lannister" => %("Why is every god so vicious? Why aren't there gods of tits and wine?"),
      "Cercei Lannister" => %("Everyone except us is our enemy."),
    })
  end

  factory :text_question do
    content "Which family does Khaleesi belong to?"
    answer "Targaryen"
  end

  factory :played_quiz do
    begin_time 1.minute.ago
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
        when TextQuestion
          wrong_answer = question.answer.reverse
        end
        answer = [wrong_answer, question.answer, Question::NO_ANSWER, nil][categories[question.category]]
        categories[question.category] += 1
        answer
      end
    end
  end

  factory :quiz_snapshot do
  end

  factory :post do
    title "Post title"
    body "Post body"
  end
end
