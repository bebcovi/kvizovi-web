require "spec_helper"

describe RegistrationsController do
  describe "#new" do
    context "when student" do
      it "doesn't require authorization" do
        get :new, type: "student"
        expect(response).not_to be_a_redirect
      end
    end

    context "when school" do
      context "when not authorized" do
        it "requires authorization" do
          get :new, type: "school"
          expect(response).to redirect_to new_authorization_path(type: "school")
        end
      end

      context "when authorized" do
        it "assigns @user" do
          get :new, {type: "school"}, {}, {authorized: true}
          expect(assigns(:user)).to be_a_new(School)
        end

        it "renders :new" do
          get :new, {type: "school"}, {}, {authorized: true}
          expect(response).to render_template(:new)
        end
      end
    end
  end

  describe "#create" do
    context "when valid" do
      before do
        School.any_instance.stub(:valid?).and_return(true)
        School.any_instance.stub(:save)
        ExampleQuizzesCreator.any_instance.stub(:create)
      end

      it "saves the user" do
        School.any_instance.unstub(:save)
        expect {
          post :create, type: "school"
        }.to change{School.count}.by 1
      end

      context "when school" do
        it "creates example quizzes" do
          ExampleQuizzesCreator.any_instance.should_receive(:create)
          post :create, type: "school"
        end
      end

      it "log the created student in" do
        controller.should_receive(:log_in!)
        post :create, type: "school"
      end

      it "redirects to root" do
        post :create, type: "school"
        expect(response).to redirect_to(root_path)
      end
    end

    context "when invalid" do
      before do
        School.any_instance.stub(:valid?).and_return(false)
      end

      it "assigns the user and its attributes" do
        post :create, type: "school", school: {name: "New name"}
        expect(assigns(:user)).to be_a_new(School)
        expect(assigns(:user).name).to eq "New name"
      end

      it "renders :new" do
        post :create, type: "school"
        expect(flash).to render_template(:new)
      end
    end
  end
end
