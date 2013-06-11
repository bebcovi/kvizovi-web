require "spec_helper"

describe RegistrationsController, user: :school do
  describe "#new" do
    context "when school", user: :school do
      it "requires authorization" do
        get :new
        expect(response).to redirect_to(new_authorization_path)
        get :new, {}, {}, {authorized: true}
        expect(response).to be_a_success
      end
    end

    context "when student", user: :student do
      it "doesn't require authorization" do
        get :new
        expect(response).to be_a_success
      end
    end
  end

  describe "#create" do
    context "when valid" do
      before do
        valid!(School)
        ExampleQuizzesCreator.any_instance.stub(:create)
      end

      it "creates the user" do
        post :create
        expect(School.count).to eq 1
      end

      context "when school", user: :school do
        it "creates example quizzes" do
          ExampleQuizzesCreator.any_instance.should_receive(:create)
          post :create
        end
      end

      it "logs the user in" do
        post :create
        expect(cookies[:user_id]).not_to be_nil
      end
    end

    context "when invalid" do
      before { invalid!(School) }

      it "doesn't raise errors" do
        post :create
      end
    end
  end

  describe "#delete" do
    before do
      @user = FactoryGirl.create(:school)
      login_as(@user)
    end

    it "doesn't raise errors" do
      get :delete
    end
  end

  describe "#destroy" do
    before do
      @user = FactoryGirl.create(:school)
      login_as(@user)
    end

    context "when valid" do
      before { @user.class.any_instance.stub(:authenticate) { @user } }

      it "destroys the user" do
        delete :destroy
        expect(@user.class.exists?(@user)).to be_false
      end

      it "logs the user out" do
        delete :destroy
        expect(cookies[:user_id]).to be_nil
      end
    end

    context "when invalid" do
      before { @user.class.any_instance.stub(:authenticate) { false } }

      it "doesn't raise errors" do
        delete :destroy
      end
    end
  end
end
