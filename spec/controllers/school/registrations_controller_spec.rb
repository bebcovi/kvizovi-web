require "spec_helper"

describe School::RegistrationsController do
  before do
    controller.stub(:authenticate!)
  end

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

  describe "#delete" do
    before do
      controller.stub(:current_user)
    end

    it "renders :delete" do
      get :delete
      expect(response).to render_template(:delete)
    end
  end

  describe "#destroy" do
    before(:all) { @school = create(:school) }

    before do
      controller.stub(:current_user).and_return(@school)
    end

    context "when valid" do
      before do
        School.any_instance.stub(:authenticate).and_return(true)
        School.any_instance.stub(:destroy)
      end

      it "deletes the school" do
        School.any_instance.unstub(:destroy)
        transaction_with_rollback do
          expect {
            delete :destroy
          }.to change{School.count}.by -1
        end
      end

      it "logs the school out" do
        delete :destroy
        expect(cookies[:user_id]).to be_nil
      end

      it "redirects to root" do
        delete :destroy
        expect(response).to redirect_to(root_path)
      end

      it "sets a flash notice" do
        delete :destroy
        expect(flash[:notice]).not_to be_nil
      end
    end

    context "when not valid" do
      before do
        School.any_instance.stub(:authenticate).and_return(false)
      end

      it "sets an alert message" do
        delete :destroy
        expect(flash[:alert]).not_to be_nil
      end

      it "renders :delete" do
        delete :destroy
        expect(response).to render_template(:delete)
      end
    end

    after(:all) { @school.destroy }
  end
end
