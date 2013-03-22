require "spec_helper"

describe UserAuthenticator do
  before do
    @it = UserAuthenticator.new(School)
  end

  describe "#authenticate" do
    it "returns false when the user doesn't exist" do
      expect(@it.authenticate(username: "janko", password: "janko")).to be_false
    end

    it "returns false when the user exists but doesn't have the corresponding password" do
      user = create(:school)
      expect(@it.authenticate(username: user.username, password: "wrong")).to be_false
    end

    it "returns the user if the user exists and has the corresponding password" do
      user = create(:school)
      expect(@it.authenticate(username: user.username, password: user.password)).to eq user
    end
  end
end
