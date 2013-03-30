require "spec_helper"

describe UserAuthenticator do
  before do
    @it = UserAuthenticator.new(School)
  end

  describe "#authenticate" do
    context "when user is not found" do
      it "returns false" do
        School.stub(:find_by_username).with("janko").and_return(nil)
        expect(@it.authenticate("janko", "secret")).to be_false
      end
    end

    context "when user is found" do
      context "and doesn't match the password" do
        before do
          @user = stub(password_digest: BCrypt::Password.create("foo"))
        end

        it "returns false" do
          School.stub(:find_by_username).with("janko").and_return(@user)
          expect(@it.authenticate("janko", "secret")).to be_false
        end
      end

      context "and matches the password" do
        before do
          @user = stub(password_digest: BCrypt::Password.create("secret"))
        end

        it "returns the user" do
          School.stub(:find_by_username).with("janko").and_return(@user)
          expect(@it.authenticate("janko", "secret")).to eq @user
        end
      end
    end
  end
end
