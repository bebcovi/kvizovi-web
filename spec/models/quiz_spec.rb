require 'spec_helper_lite'
require_relative "../../app/models/quiz"

describe Quiz do
  before(:each) { @it = build(:quiz) }
  subject { @it }

  use_nulldb

  it "removes blanks and converts to integer when assigning grades" do
    @it.grades = ["1", "", "2"]
    @it.grades.should eq [1, 2]
  end

  describe "validations" do
    context "upon activation" do
      before(:each) { @it.activated = true }

      it "has to have at least 2 questions" do
        require_relative "../../app/models/question/boolean_question"

        @it.stub(:questions).and_return([build(:boolean_question)])
        @it.should_not be_valid

        @it.stub(:questions).and_return([build(:boolean_question), build(:boolean_question)])
        @it.should be_valid
      end

      it "has to have an even number of each category of questions" do
        require_relative "../../app/models/question/boolean_question"
        require_relative "../../app/models/question/text_question"

        @it.stub(:questions).and_return([build(:boolean_question), build(:text_question)])
        @it.should_not be_valid
      end
    end
  end
end

