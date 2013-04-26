require "spec_helper"

describe PlayedQuizExhibit do
  before do
    @it = PlayedQuizExhibit.new(played_quiz)
  end

  let(:played_quiz) do
    PlayedQuiz.build_from_hash(quiz_state.to_h)
  end

  let(:quiz_state) do
    store = {}
    QuizState.new(store).tap do
      quiz_runner = QuizRunner.new(store)
      quiz_runner.prepare!(hash)
      quiz_runner.save_answer!(true);  quiz_runner.next_question!
      quiz_runner.save_answer!(true);  quiz_runner.next_question!
      quiz_runner.save_answer!(false); quiz_runner.next_question!
      quiz_runner.save_answer!(true);  quiz_runner.next_question!
      quiz_runner.finish!
    end
  end

  let(:hash) do
    {
      quiz_id:      1,
      question_ids: (1..4).to_a,
      student_ids:  Factory.create_list(:student, 2).map(&:id),
    }
  end

  it "has results" do
    @it.results
  end

  it "has scores" do
    expect(@it.scores).to eq [1, 2]
  end

  it "has score percentages" do
    expect(@it.score_percentages).to eq [50, 100]
  end

  it "has student numbers" do
    expect(@it.student_numbers).to eq [1, 2]
  end

  it "has ranks" do
    @it.ranks.each do |rank|
      expect(rank).to be_present
    end
  end

  it "has total score" do
    expect(@it.total_score).to eq 2
  end
end
