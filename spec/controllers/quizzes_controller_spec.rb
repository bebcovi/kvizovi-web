require "spec_helper"

describe QuizzesController do
  before(:all) { @user = create(:school) }

  before do
    controller.send(:log_in!, @user)
  end

  context "collection" do
    describe "#index" do
      it "assigns user's quizzes" do
        user_quiz = create(:quiz, school: @user)
        other_quiz  = create(:quiz)
        get :index
        expect(assigns(:quizzes)).to eq [user_quiz]
      end

      it "renders :index" do
        get :index
        expect(response).to render_template(:index)
      end
    end

    describe "#new" do
      it "assigns new quiz" do
        get :new
        expect(assigns(:quiz)).to be_a_new(Quiz)
      end

      it "renders :new" do
        get :new
        expect(response).to render_template(:new)
      end
    end

    describe "#create" do
      it "assigns attributes" do
        post :create, quiz: {name: "janko"}
        expect(assigns(:quiz).name).to eq "janko"
      end

      context "when valid" do
        before do
          Quiz.any_instance.stub(:valid?).and_return(true)
          Quiz.any_instance.stub(:save)
        end

        it "saves the record" do
          Quiz.any_instance.unstub(:save)
          expect {
            post :create
          }.to change{@user.quizzes.count}.by 1
        end

        it "redirects to quizzes" do
          post :create
          expect(response).to redirect_to(quizzes_path)
        end

        it "sets a flash notice" do
          post :create
          expect(flash[:notice]).not_to be_nil
        end
      end

      context "when invalid" do
        before do
          Quiz.any_instance.stub(:valid?).and_return(false)
        end

        it "assigns new quiz" do
          post :create
          expect(assigns(:quiz)).to be_a_new(Quiz)
        end

        it "renders :new" do
          post :create
          expect(response).to render_template(:new)
        end
      end
    end
  end

  context "member" do
    before(:all) { @quiz = create(:quiz, school: @user) }

    describe "#edit" do
      it "assigns quiz" do
        get :edit, id: @quiz.id
        expect(assigns(:quiz)).not_to be_nil
      end

      it "renders :edit" do
        get :edit, id: @quiz.id
        expect(response).to render_template(:edit)
      end
    end

    describe "#update" do
      it "scopes to current user" do
        quiz = create(:quiz)
        expect {
          put :update, id: quiz.id
        }.to raise_error
      end

      context "when valid" do
        before do
          Quiz.any_instance.stub(:valid?).and_return(true)
          Quiz.any_instance.stub(:save)
        end

        it "saves the record" do
          Quiz.any_instance.unstub(:save)
          put :update, id: @quiz.id, quiz: {name: "New name"}
          expect(@quiz.reload.name).to eq "New name"
        end

        it "redirects to quizzes" do
          put :update, id: @quiz.id
          expect(response).to redirect_to(quizzes_path)
        end

        it "sets a flash notice" do
          put :update, id: @quiz.id
          expect(flash[:notice]).not_to be_nil
        end
      end

      context "when invalid" do
        before do
          Quiz.any_instance.stub(:valid?).and_return(false)
        end

        it "assigns quiz and its attributes" do
          put :update, id: @quiz.id, quiz: {name: "New name"}
          expect(assigns(:quiz)).to eq @quiz
          expect(assigns(:quiz).name).to eq "New name"
        end

        it "renders :edit" do
          put :update, id: @quiz.id
          expect(response).to render_template(:edit)
        end
      end
    end

    describe "#toggle_activation" do
      context "when quiz is activated" do
        before do
          @quiz.update_column(:activated, true)
        end

        it "deactivates the quiz" do
          expect {
            put :toggle_activation, id: @quiz.id
          }.to change{@quiz.reload.activated?}.to(false)
        end
      end

      context "when quiz is not activated" do
        before do
          @quiz.update_column(:activated, false)
        end

        it "activates the quiz" do
          expect {
            put :toggle_activation, id: @quiz.id
          }.to change{@quiz.reload.activated?}.to(true)
        end
      end

      it "redirects to quizzes" do
        put :toggle_activation, id: @quiz.id
        expect(response).to redirect_to(quizzes_path)
      end
    end

    describe "#delete" do
      it "assigns quiz" do
        get :delete, id: @quiz.id
        expect(assigns(:quiz)).to eq @quiz
      end

      it "renders :delete" do
        get :delete, id: @quiz.id
        expect(response).to render_template(:delete)
      end
    end

    describe "#destroy" do
      before do
        Quiz.any_instance.stub(:destroy)
      end

      it "scopes to current user" do
        quiz = create(:quiz)
        expect {
          delete :destroy, id: quiz.id
        }.to raise_error
      end

      it "destroyes the quiz" do
        Quiz.any_instance.unstub(:destroy)
        quiz = create(:quiz, school: @user)
        expect {
          delete :destroy, id: quiz.id
        }.to change{@user.quizzes.count}.by -1
      end

      it "redirects to quizzes path" do
        delete :destroy, id: @quiz.id
        expect(response).to redirect_to(quizzes_path)
      end

      it "sets a flash notice" do
        delete :destroy, id: @quiz.id
        expect(flash[:notice]).not_to be_nil
      end
    end

    after(:all) { @quiz.destroy }
  end

  after(:all) { @user.destroy }
end
