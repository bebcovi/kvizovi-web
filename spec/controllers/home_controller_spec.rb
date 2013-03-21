require "spec_helper"

describe HomeController do
  before do
    @parameters = {}
  end

  describe "#index" do
    context "when user is not logged in" do
      it "renders :index" do
        get :index, @parameters
        expect(response).to render_template(:index)
      end
    end

    context "when school logged in" do
      before do
        controller.stub(:current_user).and_return(School.new)
      end

      it "redirects to quizzes" do
        get :index, @parameters
        expect(response).to redirect_to(quizzes_path)
      end
    end

    context "when student logged in" do
      before do
        controller.stub(:current_user).and_return(Student.new)
      end

      it "redirects to new game" do
        get :index, @parameters
        expect(response).to redirect_to(new_game_path)
      end
    end
  end
end
