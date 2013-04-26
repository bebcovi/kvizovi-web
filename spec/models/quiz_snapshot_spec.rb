require "spec_helper"

describe QuizSnapshot do
  enable_paper_trail

  before do
    @quiz = Factory.create(:quiz, name: "Name")
    @quiz.questions = [
      Factory.create(:boolean_question,     content: "Boolean", answer: true),
      Factory.create(:choice_question,      content: "Choice", provided_answers: ["Foo", "Bar", "Baz"]),
      Factory.create(:association_question, content: "Association", associations: {"Foo" => "Foo", "Bar" => "Bar"}),
      Factory.create(:text_question,        content: "Text", answer: "Answer"),
      Factory.create(:image_question,       content: "Image", image: uploaded_file("image.jpg", "image/jpeg"), answer: "Answer"),
    ]
  end

  it "captures a snapshot of a quiz" do
    QuizSnapshot.capture(@quiz)
    @quiz.destroy

    @it = QuizSnapshot.first # So that nothing is cached

    quiz = @it.quiz
    expect(quiz).to be_present
    expect(quiz.name).to eq "Content"

    boolean_question = @it.questions.first
    expect(boolean_question.content).to eq "Boolean"
    expect(boolean_question.answer).to eq true

    choice_question = @it.questions.second
    expect(choice_question.content).to eq "Choice"
    expect(choice_question.provided_answers).to eq ["Foo", "Bar", "Baz"]

    association_question = @it.questions.third
    expect(association_question.content).to eq "Association"
    expect(association_question.associations).to eq({"Foo" => "Foo", "Bar" => "Bar"})

    text_question = @it.questions.fourth
    expect(text_question.content).to eq "Text"
    expect(text_question.answer).to eq "Answer"

    image_question = @it.questions.fifth
    expect(image_question.content).to eq "Image"
    expect(image_question.answer).to eq "Answer"
    expect(image_question.image.path).to satisfy { |path| File.exists?(path) }
    expect(image_question.image_width).to be_present
  end
end
