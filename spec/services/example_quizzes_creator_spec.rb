require "spec_helper"

describe ExampleQuizzesCreator do
  before do
    @school = create(:school)
    @it = ExampleQuizzesCreator.new(@school)
  end

  describe "#create" do
    it "creates some quizzes with some questions" do
      @it.create
      expect(@school.quizzes.count).to be > 0
      @school.quizzes.each do |quiz|
        expect(quiz.questions.count).to be > 0
      end
    end
  end
end
