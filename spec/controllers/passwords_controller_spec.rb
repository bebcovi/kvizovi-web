require "spec_helper"

describe PasswordsController do
  before do
    @parameters = {}
    @school = create(:school)
  end

  describe "#new" do
    it "renders :new" do
      get :new, @parameters
      expect(response).to render_template(:new)
    end
  end

  describe "#create" do
    context "when valid" do
      before do
        @parameters.update(email: @school.email)
      end

      it "resets the password" do
        expect {
          post :create, @parameters
        }.to change{@school.reload.password_digest}
      end

      it "sends the email with the new password" do
        post :create, @parameters
        expect(ActionMailer::Base.deliveries).to have(1).item
        expect(ActionMailer::Base.deliveries.first.to).to eq [@school.email]
      end

      it "redirects to login page" do
        post :create, @parameters
        expect(response).to redirect_to(login_path(type: "school"))
      end

      it "sets a flash message" do
        post :create, @parameters
        expect(flash).to have_notice_message
      end
    end

    context "when invalid" do
      it "sets the alert message" do
        post :create, @parameters
        expect(flash).to have_alert_message
      end

      it "renders :new" do
        post :create, @parameters
        expect(response).to render_template(:new)
      end
    end
  end

  describe "#edit" do
    it "renders :edit" do
      get :edit, @parameters
      expect(response).to render_template(:edit)
    end
  end

  describe "#update" do
    before do
      controller.stub(:current_user).and_return(@school)
    end

    context "when valid" do
      before do
        @parameters.update(password: {old: @school.password, new: @school.password, new_confirmation: @school.password})
      end

      it "updates the password" do
        expect {
          put :update, @parameters
        }.to change{@school.reload.password_digest}
      end

      it "sets a flash message" do
        put :update, @parameters
        expect(flash).to have_notice_message
      end

      it "redirects to profile" do
        put :update, @parameters
        expect(response).to redirect_to(school_path(@school))
      end
    end

    context "when invalid" do
      before do
        @parameters.update(password: {old: @school.password})
      end

      it "assigns @password and its attributes" do
        put :update, @parameters
        expect(assigns(:password)).not_to be_nil
        expect(assigns(:password).old).to eq @school.password
      end

      it "renders :edit" do
        put :update, @parameters
        expect(response).to render_template(:edit)
      end
    end
  end
end
