require "spec_helper"

describe Login do
  before do
    @it = Login.new(username: "janko", password: "secret")
  end

  context "validations" do
    before do
      @it.user_class = Student
    end

    it "validates authentication of user and assigns the user" do
      user = stub
      UserAuthenticator.any_instance.stub(:authenticate).with("janko", "secret").and_return(user)
      expect(@it).to be_valid
      expect(@it.user).to eq user

      UserAuthenticator.any_instance.stub(:authenticate).with("janko", "secret").and_return(false)
      expect(@it).not_to be_valid
    end
  end
end
