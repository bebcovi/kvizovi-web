require_relative "../../app/models/password"
require_relative "../../app/models/student"

describe Password do
  before(:each) { @it = Password.new(old_password: "secret", new_password: "secret", new_password_confirmation: "secret") }
  subject { @it }

  use_nulldb

  describe "validations" do
    it "validates the old password" do
      @it.user = build(:student, school_id: 1)
      @it.old_password = "wrong password"
      @it.should_not be_valid

      @it.old_password = attributes_for(:student)[:password]
      @it.should be_valid
    end

    it "validates presence of the new password" do
      @it.stub(:validate_old_password) { true }
      @it.new_password = nil
      @it.should_not be_valid
    end

    it "validates confirmation of the new password" do
      @it.stub(:validate_old_password) { true }
      @it.new_password_confirmation = "wrong password"
      @it.should_not be_valid
    end
  end
end
