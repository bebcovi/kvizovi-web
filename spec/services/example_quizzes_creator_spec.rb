require "spec_helper"

describe ExampleQuizzesCreator do
  before do
    @user = Factory.create_without_validation(:empty_school)
    @it = ExampleQuizzesCreator.new(@user)
  end

  describe "#create" do
    it "creates some quizzes with some questions" do
      @it.create
      expect(@user.quizzes.count).to be > 0
      @user.quizzes.each do |quiz|
        expect(quiz.questions.count).to be > 0
      end
    end
  end
end
