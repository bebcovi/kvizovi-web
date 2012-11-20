require "spec_helper_full"

describe Quiz do
  before(:all) { @it = create(:quiz) }
  subject { @it }

  describe "grades" do
    before(:all) { @it.update_attributes(grades: ["1a", "2b", "3c"]) }

    it "assigns them correctly" do
      @it.reload.grades.should eq ["1a", "2b", "3c"]
    end

    it "knows for which grades is it intended for" do
      Quiz.for_student(stub(grade: "1a")).should eq [@it]
      Quiz.for_student(stub(grade: "4b")).should_not eq [@it]
    end
  end

  after(:all) { @it.destroy }
end
