require "spec_helper"

describe ExampleQuizzesCreator do
  let(:it) { described_class.new(school) }
  let(:school) { create(:school) }

  describe "#create" do
    it "creates some quizzes with some questions" do
      it.create
      expect(school.quizzes).not_to be_empty
      school.quizzes.each do |quiz|
        expect(quiz.questions).not_to be_empty
      end
    end
  end
end
