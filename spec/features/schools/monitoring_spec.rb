require "spec_helper"

feature "Monitoring" do
  let!(:school) { register(:school) }
  let(:quiz) { create(:quiz) }

  def create_played_quiz(options = {})
    school.quizzes << quiz
    quiz.questions = create_questions(options[:full] ? 20 : 0)
    school.students << create_list(:student, 2)

    create(:played_quiz,
      quiz_snapshot: QuizSnapshot.capture(quiz),
      players:       school.students,
    )
  end

  def create_questions(number)
    number.times.map do |idx|
      create(:"#{Question::CATEGORIES[idx % 4]}_question")
    end
  end

  background do
    login(school)
  end

  scenario "Viewing a quiz" do
    played_quiz = create_played_quiz
    click_on "Kvizovi"
    click_on "Prati"

    expect(page).to have_content(played_quiz.quiz.name)
  end

  scenario "Viewing a student" do
    played_quiz = create_played_quiz
    click_on "Učenici"
    within(played_quiz.players.first) { click_on "1" }

    expect(page).to have_content(played_quiz.quiz.name)
  end

  scenario "Viewing all quizzes" do
    played_quiz = create_played_quiz
    click_on "Odigrani kvizovi"

    expect(page).to have_content(played_quiz.quiz.name)
  end

  scenario "Viewing full game" do
    played_quiz = create_played_quiz(full: true)
    click_on "Odigrani kvizovi"
    click_on played_quiz.quiz.name

    expect(page).to have_content(played_quiz.questions.first.content)
  end
end
