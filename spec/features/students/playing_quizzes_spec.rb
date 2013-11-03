require "spec_helper"

feature "Playing quizzes" do
  let!(:student)      { register(:student, school: school) }
  let(:school)        { create(:school) }
  let(:quiz)          { create(:quiz, questions: create_questions(4)) }

  def create_questions(number)
    number.times.map do |idx|
      create(:"#{Question::CATEGORIES[idx % 4]}_question")
    end
  end

  def answers(&block)
    loop do
      block.call

      if page.has_link?("Sljedeće pitanje")
        click_on "Sljedeće pitanje"
      else
        break
      end
    end
  end

  def connect(hash)
    hash.each_with_index do |(left, right), index|
      divs = all(".association-pair")[index].all("td")
      divs.first.fill_in :play_answer, with: left
      divs.last.fill_in :play_answer, with: right
    end
  end

  def answer_question_correctly
    case
    when page.has_content?("Eliminate the bastard.")
      choose "Jon Snow"
    when page.has_content?("Connect Game of Thrones characters:")
      connect(
        "Sansa Stark"      => %("...but I don't want anyone smart, brave or good looking, I want Joffrey!"),
        "Tywin Lannister"  => %("Attacking Ned Stark in the middle of King Landing was stupid. Lannisters don't do stupid things."),
        "Tyrion Lannister" => %("Why is every god so vicious? Why aren't there gods of tits and wine?"),
        "Cercei Lannister" => %("Everyone except us is our enemy."),
      )
    when page.has_content?("Stannis Baratheon won the war against King’s Landing.")
      choose "Netočno"
    when page.has_content?("Which family does Khaleesi belong to?")
      fill_in "Odgovor", with: "Targaryen"
    else
      raise "Unknown question"
    end

    click_on "Odgovori"
    expect(page.title).to match "Točan odgovor"
  end

  def answer_question_incorrectly
    click_on "Odgovori"
    expect(page.title).to match "Netočan odgovor"
  end

  def begin_single_player
    choose quiz.name
    choose "Samo ja"
    click_on "Započni kviz"
  end

  def begin_multi_player(other_student)
    choose quiz.name
    choose "Još netko"
    fill_in "Korisničko ime", with: other_student.username
    fill_in "Lozinka",        with: other_student.password
    click_on "Započni kviz"
  end

  before do
    login(student)
  end

  scenario "Single player" do
    school.quizzes << quiz

    click_on "Kvizovi"
    begin_single_player
    answers { answer_question_correctly }
    click_on "Rezultati"

    expect(first(".l-player-one")).to have_content("4 od 4")
  end

  scenario "Multi player" do
    school.quizzes << quiz
    school.students << (other_student = create(:student))

    click_on "Kvizovi"
    begin_multi_player(other_student)
    answers { answer_question_correctly }
    click_on "Rezultati"

    expect(first(".l-player-one")).to have_content("2 od 2")
    expect(first(".l-player-two")).to have_content("2 od 2")
  end

  scenario "Not getting all points" do
    school.quizzes << quiz

    click_on "Kvizovi"
    begin_single_player
    answers { answer_question_incorrectly }
    click_on "Rezultati"

    expect(first(".l-player-one")).to have_content("0 od 4")
  end

  scenario "Aborting" do
    school.quizzes << quiz

    click_on "Kvizovi"
    begin_single_player
    click_on "Prekini"
    click_on "Jesam"

    expect(current_path).to eq choose_quiz_path
  end

  scenario "Quiz gets deleted in the meanwhile" do
    school.quizzes << quiz

    click_on "Kvizovi"
    begin_single_player
    quiz.destroy

    expect {
      answers { answer_question_correctly }
      click_on "Rezultati"
    }.not_to raise_error
  end

  scenario "Quizzes from other schools" do
    other_school = create(:school)
    other_school.quizzes << quiz

    click_on "Kvizovi"
    click_on "Druge škole"
    expect(find("#other")).to have_content(quiz.name)

    begin_single_player
    answers { answer_question_correctly }
    click_on "Rezultati"

    expect(first(".l-player-one")).to have_content("4 od 4")
  end
end
