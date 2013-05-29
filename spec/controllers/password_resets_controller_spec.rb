require "spec_helper"
require "nokogiri"

describe PasswordResetsController, user: :school do
  before do
    @user = Factory.create(:school, email: "jon.snow@example.com")
  end

  describe "#new" do
    it "doesn't raise errors" do
      get :new
    end
  end

  describe "#confirm" do
    context "when valid" do
      it "assigns the confirmation ID to the user" do
        PasswordResetService.any_instance.should_receive(:generate_confirmation_id)
        post :confirm, email: @user.email
      end

      it "sends the confirmation email" do
        post :confirm, email: @user.email
        expect(ActionMailer::Base.deliveries).to have(1).item
        expect(ActionMailer::Base.deliveries.first.to).to eq [@user.email]
      end

      it "assigns a flash message" do
        post :confirm, email: @user.email
        expect(flash[:notice]).to be_present
      end

      context "when student", user: :student do
        before do
          @user = Factory.create(:student, school: @user)
        end

        it "finds by username" do
          PasswordResetService.any_instance.should_receive(:generate_confirmation_id)
          post :confirm, username: @user.username, email: "janko@example.com"
        end

        it "sends the email to student's school" do
          post :confirm, username: @user.username, email: "janko@example.com"
          expect(ActionMailer::Base.deliveries.first.to).to include(@user.school.email)
        end

        it "requires the email address" do
          PasswordResetService.any_instance.should_not_receive(:generate_confirmation_id)
          post :confirm, username: @user.username
        end
      end
    end

    context "when invalid" do
      it "doesn't raise errors" do
        post :confirm
      end
    end
  end

  describe "#create" do
    it "compares the confirmation ID" do
      PasswordResetService.any_instance.should_not_receive(:reset_password)
      post :create, email: @user.email, confirmation_id: "foo"
    end

    context "when valid" do
      before do
        @user.update_attributes(password_reset_confirmation_id: "foo")
      end

      it "resets the password" do
        PasswordResetService.any_instance.should_receive(:reset_password)
        post :create, email: @user.email, confirmation_id: "foo"
      end

      it "emails the resetted password" do
        post :create, email: @user.email, confirmation_id: "foo"
        expect(ActionMailer::Base.deliveries).to have(1).item
        expect(ActionMailer::Base.deliveries.first.to).to eq [@user.email]
      end

      context "when student", user: :student do
        before do
          @user = Factory.create(:student, school: @user)
        end

        it "finds by username" do
          PasswordResetService.any_instance.should_receive(:reset_password)
          post :create, username: @user.username, email: "janko@example.com"
        end

        it "sends the new password to the student" do
          post :create, username: @user.username, email: "janko@example.com"
          expect(ActionMailer::Base.deliveries.last.to).to include("janko@example.com")
        end
      end
    end

    context "when not valid" do
      it "doesn't raise errors" do
        post :create
      end
    end
  end
end
