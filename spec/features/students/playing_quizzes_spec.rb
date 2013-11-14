require "spec_helper"

feature "Playing quizzes" do
  let!(:student)  { register(:student, school: school) }
  let(:school)    { create(:school) }
  let(:quiz)      { create(:quiz, questions: questions) }
  let(:questions) { Question::CATEGORIES.map { |category| create(:"#{category}_question") } }

  def answers(&block)
    loop do
      block.call

      if find(".modal-footer .btn").text =~ /Sljedeće pitanje/
        click_on "Sljedeće pitanje"
      else
        break
      end
    end
  end

  def connect(mappings)
    mappings.each_with_index do |(right, left), index|
      divs = all(".association-pair")[index].all("td")
      divs.first.fill_in :play_answer, with: left, visible: false
      divs.last.fill_in :play_answer, with: right, visible: false
    end
  end

  def answer_question_correctly
    case first(".question-title").text
    when /Eliminate the bastard\./
      choose "Jon Snow"
    when /Connect Game of Thrones characters:/
      connect(
        %("...but I don't want anyone smart, brave or good looking, I want Joffrey!")                         => "Sansa Stark",
        %("Attacking Ned Stark in the middle of King Landing was stupid. Lannisters don't do stupid things.") => "Tywin Lannister",
        %("Why is every god so vicious? Why aren't there gods of tits and wine?")                             => "Tyrion Lannister",
        %("Everyone except us is our enemy.")                                                                 => "Cercei Lannister",
      )
    when /Stannis Baratheon won the war against King’s Landing\./
      choose "Netočno"
    when /Which family does Khaleesi belong to\?/
      fill_in "Odgovor", with: "Targaryen"
    else
      raise "Unknown question"
    end

    click_on "Odgovori"
    expect(find(".modal")).to have_css(".text-success")
  end

  def answer_question_incorrectly
    click_on "Odgovori"
    expect(find(".modal")).to have_css(".text-error")
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

  background do
    login(student)
  end

  scenario "Single player", js: true do
    school.quizzes << quiz

    click_on "Kvizovi"
    begin_single_player
    answers { answer_question_correctly }
    click_on "Rezultati"

    expect(first(".l-player-one")).to have_content("4 od 4")
  end

  scenario "Multi player", js: true do
    school.quizzes << quiz
    school.students << (other_student = create(:student))

    click_on "Kvizovi"
    begin_multi_player(other_student)
    answers { answer_question_correctly }
    click_on "Rezultati"

    expect(first(".l-player-one")).to have_content("2 od 2")
    expect(first(".l-player-two")).to have_content("2 od 2")
  end

  scenario "Not getting all points", js: true do
    school.quizzes << quiz

    click_on "Kvizovi"
    begin_single_player
    answers { answer_question_incorrectly }
    click_on "Rezultati"

    expect(first(".l-player-one")).to have_content("0 od 4")
  end

  scenario "Aborting", js: true do
    school.quizzes << quiz

    click_on "Kvizovi"
    begin_single_player
    click_on "Prekini"
    click_on "Jesam"

    expect(current_path).to eq choose_quiz_path
  end

  scenario "Quiz gets deleted in the meanwhile", js: true do
    school.quizzes << quiz

    click_on "Kvizovi"
    begin_single_player
    quiz.destroy

    expect {
      answers { answer_question_correctly }
      click_on "Rezultati"
    }.not_to raise_error
  end
end
