require "spec_helper"

describe RegistrationsController do
  before do
    @parameters = {}
  end

  describe "#new" do
    context "with student" do
      before do
        @parameters.update(type: "student")
      end

      it "renders the template" do
        get :new, @parameters
        expect(response).to render_template(:new)
      end
    end

    context "with school" do
      before do
        @parameters.update(type: "school")
      end

      context "when not authorized" do
        it "requires authorization" do
          get :new, @parameters
          expect(response).to redirect_to new_authorization_path
        end
      end

      context "when authorized" do
        before do
          controller.stub(:flash).and_return({authorized: true})
        end

        it "renders :new" do
          get :new, @parameters
          expect(response).to render_template(:new)
        end
      end
    end
  end

  describe "#create" do
    before do
      @parameters.update(type: "student")
    end

    context "when valid" do
      before do
        @parameters.update(student: attributes_for(:student))
      end

      it "creates a new student" do
        post :create, @parameters
        Student.count.should eq 1
      end

      it "log the created student in" do
        post :create, @parameters
        expect(cookies[:user_id]).not_to be_nil
      end
    end

    context "when invalid" do
      before do
        @parameters.update(student: attributes_for(:student).slice(:username))
      end

      it "assigns @user and its attributes" do
        post :create, @parameters
        expect(assigns(:user)).not_to be_nil
        expect(assigns(:user).username).to eq @parameters[:student][:username]
      end

      it "renders :new" do
        post :create, @parameters
        expect(flash).to render_template(:new)
      end
    end
  end
end
