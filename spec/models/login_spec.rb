require "spec_helper"

describe Login do
  before do
    @it = Login.new(username: "janko", password: "janko")
  end

  describe "#valid?" do
    it "calls the UserAuthenticator" do
      UserAuthenticator.any_instance.should_receive(:authenticate).with(username: "janko", password: "janko")
      @it.valid?
    end

    it "assigns the #user" do
      user = stub
      UserAuthenticator.any_instance.stub(:authenticate).and_return(user)
      @it.valid?
      expect(@it.user).to eq user
    end
  end
end
