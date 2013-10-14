require "spec_helper"

describe PlayedQuizCreator do
  before do
    @it = PlayedQuizCreator.new(quiz_play)
  end

  let(:quiz_play) do
    double(
      quiz_snapshot: {id: 1},
      questions:     [{answer: "foo"}],
      begin_time:    1.minute.ago,
      end_time:      Time.now,
      students:      FactoryGirl.create_list(:student, 2),
    )
  end

  describe "#create" do
    it "creates the played quiz" do
      @it.create
      expect(PlayedQuiz.count).to eq 1
    end

    it "adds the played quiz to students" do
      @it.create
      quiz_play.students.each do |student|
        expect(student.played_quizzes.count).to eq 1
      end
    end
  end
end
