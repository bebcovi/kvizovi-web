require "spec_helper"

describe RegistrationsController do
  describe "#new"

  describe "#create" do
    context "when school" do
      before { request.host = "school.example.com" }

      context "when valid" do
        before { School.any_instance.stub(:valid?).and_return(true) }

        it "creates example quizzes" do
          post :create
          expect(School.first.quizzes).not_to be_empty
        end
      end
    end
  end

  describe "#delete"
  describe "#destroy"
end
