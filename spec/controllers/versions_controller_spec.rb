require "spec_helper"

describe VersionsController, user: :school do
  enable_paper_trail

  describe "#revert" do
    before do
      request.env["HTTP_REFERER"] = root_path
    end

    it "reverts the destroy" do
      question = Factory.create(:question)
      question.class.any_instance.stub(:valid?) { true }
      question.destroy
      post :revert, id: question.versions.scoped.last.id
      expect(question).to satisfy { |q| Question.exists?(q) }
    end
  end
end
