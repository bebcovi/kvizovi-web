require "spec_helper"

describe RegistrationsController do
  describe "#new" do
    context "when not authorized" do
      it "requires authorization" do
        get :new, type: "school"
        expect(response).to redirect_to new_authorization_path
      end
    end

    context "when authorized" do
      it "assigns @user" do
        get :new, {type: "school"}, {}, {authorized: true}
        expect(assigns(:user)).not_to be_nil
      end

      it "renders :new" do
        get :new, {type: "school"}, {}, {authorized: true}
        expect(response).to render_template(:new)
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

      it "creates the user" do
        School.any_instance.should_receive(:save)
        post :create, type: "school"
      end

      context "when school" do
        it "creates example quizzes" do
          ExampleQuizzesCreator.any_instance.should_receive(:create)
          post :create, type: "school"
        end
      end

      it "log the created student in" do
        controller.should_receive(:log_in!).with(an_instance_of(School))
        post :create, type: "school"
      end
    end

    context "when invalid" do
      before do
        School.any_instance.stub(:valid?).and_return(false)
      end

      it "assigns @user and its attributes" do
        post :create, type: "school", school: {username: "janko"}
        expect(assigns(:user)).not_to be_nil
        expect(assigns(:user).username).to eq "janko"
      end

      it "renders :new" do
        post :create, type: "school"
        expect(flash).to render_template(:new)
      end
    end
  end
end
