require "spec_helper"

describe UserAuthenticator do
  before do
    @it = UserAuthenticator.new(School)
  end

  describe "#authenticate" do
    context "when user is not found" do
      it "returns false" do
        expect(@it.authenticate("janko", "secret")).to be_false
      end
    end

    context "when user is found" do
      before do
        @user = Factory.create_without_validation(:empty_school, username: "janko")
      end

      context "and doesn't match the password" do
        before do
          @user.assign_attributes(password: "foo")
          @user.save(validate: false)
        end

        it "returns false" do
          expect(@it.authenticate("janko", "secret")).to be_false
        end
      end

      context "and matches the password" do
        before do
          @user.assign_attributes(password: "secret")
          @user.save(validate: false)
        end

        it "returns the user" do
          expect(@it.authenticate("janko", "secret")).to eq @user
        end
      end
    end
  end
end
