require "spec_helper"

describe QuizSnapshot do
  it "captures a snapshot of a quiz" do
    quiz = FactoryGirl.create(:quiz, name: "Name")
    quiz.questions = [
      FactoryGirl.create(:boolean_question,     content: "Boolean", answer: true),
      FactoryGirl.create(:choice_question,      content: "Choice", provided_answers: ["Foo", "Bar", "Baz"]),
      FactoryGirl.create(:association_question, content: "Association", associations: {"Foo" => "Foo", "Bar" => "Bar"}),
      FactoryGirl.create(:text_question,        content: "Text", answer: "Answer"),
    ]
    quiz_specification = double(
      quiz: quiz,
      students: [double],
    )

    QuizSnapshot.capture(quiz_specification)
    quiz.destroy
    @it = QuizSnapshot.first # So that nothing is cached

    quiz = @it.quiz
    expect(quiz).to be_present
    expect(quiz.name).to eq "Name"

    boolean_question = @it.questions.first
    expect(boolean_question.content).to eq "Boolean"
    expect(boolean_question.answer).to eq true

    choice_question = @it.questions.second
    expect(choice_question.content).to eq "Choice"
    expect(choice_question.provided_answers).to eq ["Foo", "Bar", "Baz"]

    association_question = @it.questions.third
    expect(association_question.content).to eq "Association"
    expect(association_question.associations).to eq [["Foo", "Foo"], ["Bar", "Bar"]]

    text_question = @it.questions.fourth
    expect(text_question.content).to eq "Text"
    expect(text_question.answer).to eq "Answer"
  end

  it "trims the number of questions to be divisible by the number of students" do
    quiz = FactoryGirl.create(:quiz)
    quiz_specification = double(
      quiz: quiz,
      students: [double, double],
    )

    quiz.questions = FactoryGirl.create_list(:question, 4)
    @it = QuizSnapshot.capture(quiz_specification)
    expect(@it.questions.count).to eq 4

    quiz.questions = FactoryGirl.create_list(:question, 5)
    @it = QuizSnapshot.capture(quiz_specification)
    expect(@it.questions.count).to eq 4
  end
end
