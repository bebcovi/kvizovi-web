require "spec_helper"

describe Quiz do
  before do
    @it = Factory.build(:empty_quiz)
  end

  context "validations" do
    context "#name" do
      it "validates presence" do
        @it.name = nil
        expect(@it).to have(1).error_on(:name)
      end

      it "validates uniqueness inside a school" do
        quiz = Factory.create_without_validation(:empty_quiz, name: "Foo", school_id: 1)
        @it.assign_attributes(name: "Foo", school_id: 1)
        expect(@it).to have(1).error_on(:name)

        quiz.update_column(:school_id, 2)
        expect(@it).not_to have(1).error_on(:name)
      end
    end

    context "#school_id" do
      it "validates presence" do
        @it.school_id = nil
        expect(@it).to have(1).error_on(:school_id)
      end
    end
  end

  it "destroyes its questions upon destruction" do
    @it.save(validate: false)
    question = Factory.create_without_validation(:empty_question, quiz: @it)
    @it.destroy
    expect(question).not_to satisfy { |q| Question.exists?(q) }
  end
end

