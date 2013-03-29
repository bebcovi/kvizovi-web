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
      expect(@it).not_to be_valid

      user = create(:student, username: "janko", password: "secret")
      expect(@it).to be_valid
      expect(@it.user).to eq user
    end
  end
end
