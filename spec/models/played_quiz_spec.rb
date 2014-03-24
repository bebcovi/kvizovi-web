require "spec_helper"

describe PlayedQuiz do
  describe ".relevant_to" do
    let(:school)        { create(:school, students: [student]) }
    let(:student)       { create(:student) }
    let(:other_student) { create(:student) }

    it "returns only played quizzes by school's students" do
      played_quiz1 = create(:played_quiz)
      create(:playing, played_quiz: played_quiz1, player: student)
      create(:playing, played_quiz: played_quiz1, player: other_student)

      played_quiz2 = create(:played_quiz)
      create(:playing, played_quiz: played_quiz2, player: other_student)

      expect(described_class.relevant_to(school)).to eq [played_quiz1]
    end

    it "doesn't return duplicate records" do
      school.students << other_student
      played_quiz = create(:played_quiz)
      create(:playing, played_quiz: played_quiz, player: student)
      create(:playing, played_quiz: played_quiz, player: other_student)

      expect(described_class.relevant_to(school)).to eq [played_quiz]
    end
  end
end
