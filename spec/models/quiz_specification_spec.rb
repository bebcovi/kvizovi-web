require "spec_helper"

describe QuizSpecification do
  before do
    @it = QuizSpecification.new
  end

  context "validations" do
    context "#quiz_id" do
      it "validates presence" do @it.quiz_id = nil
        expect(@it).to have(1).error_on(:quiz_id)
      end
    end

    context "#students_count" do
      it "validates presence" do
        @it.students_count = nil
        expect(@it).to have(1).error_on(:students_count)
      end
    end

    context "#students_credentials" do
      it "validates authenticity" do
        @it.students_count = 2

        expect(@it).to have(1).error_on(:students_credentials)

        Factory.create(:student, username: "janko", password: "secret")
        Factory.create(:student, username: "matija", password: "secret")
        @it.students_credentials = [
          {username: "janko",  password: "secret"},
          {username: "matija", password: "secret"},
        ]

        expect(@it).to have(0).errors_on(:students_credentials)
      end
    end
  end
end
