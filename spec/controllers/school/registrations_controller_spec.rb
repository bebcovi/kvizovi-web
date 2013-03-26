require "spec_helper"

describe School::RegistrationsController do
  describe "#new" do
    context "when not authorized" do
      it "requires authorization" do
        get :new
        expect(response).to redirect_to new_authorization_path
      end
    end

    context "when authorized" do
      it "assigns school" do
        get :new, {}, {}, {authorized: true}
        expect(assigns(:school)).to be_a_new(School)
      end

      it "renders :new" do
        get :new, {}, {}, {authorized: true}
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

      it "saves the school" do
        School.any_instance.unstub(:save)
        expect {
          post :create
        }.to change{School.count}.by 1
      end

      it "creates example quizzes" do
        ExampleQuizzesCreator.any_instance.should_receive(:create)
        post :create
      end

      it "log the created school in" do
        controller.should_receive(:log_in!)
        post :create
      end

      it "redirects to root" do
        post :create
        expect(response).to redirect_to(root_path)
      end
    end

    context "when invalid" do
      before do
        School.any_instance.stub(:valid?).and_return(false)
      end

      it "assigns the school and its attributes" do
        post :create, school: {name: "New name"}
        expect(assigns(:school)).to be_a_new(School)
        expect(assigns(:school).name).to eq "New name"
      end

      it "renders :new" do
        post :create
        expect(flash).to render_template(:new)
      end
    end
  end
end
