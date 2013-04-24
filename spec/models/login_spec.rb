require "spec_helper"

describe Login do
  before do
    @it = Login.new(username: "janko", password: "secret")
  end

  context "validations" do
    it "validates authentication of user and assigns the user" do
      user = Factory.create(:user, username: "janko", password: "secret")
      @it.user_class = user.class

      expect(@it).to be_valid
      expect(@it.user).to eq user

      user.destroy

      expect(@it).not_to be_valid
    end
  end
end
