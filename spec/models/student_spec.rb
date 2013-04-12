require "spec_helper"

describe Student do
  before do
    @it = Factory.build(:empty_student)
  end

  describe "#grade=" do
    it "removes spaces and dots" do
      @it.grade = "4. b"
      @it.grade.should eq "4b"
    end
  end

  context "validations" do
    context "#username" do
      it "validates presence" do
        @it.username = nil
        expect(@it).to have(1).error_on(:username)
      end

      it "validates format" do
        @it.username = "@@@"
        expect(@it).to have(1).error_on(:username)
      end

      it "validates length" do
        @it.username = "ab"
        expect(@it).to have(1).error_on(:username)
      end

      it "validates uniqueness" do
        Factory.create_without_validation(:empty_student, username: "john")
        @it.username = "john"
        expect(@it).to have(1).error_on(:username)
      end
    end

    context "#password" do
      it "validates presence" do
        @it.password = nil
        expect(@it).to have(1).error_on(:password)
      end
    end

    context "#grade" do
      it "validates presence" do
        @it.grade = nil
        expect(@it).to have(1).error_on(:grade)
      end

      it "validates format" do
        @it.grade = "bla"
        expect(@it).to have(1).error_on(:grade)
      end
    end

    context "#first_name" do
      it "validates presence" do
        @it.first_name = nil
        expect(@it).to have(1).error_on(:first_name)
      end
    end

    context "#last_name" do
      it "validates presence" do
        @it.last_name = nil
        expect(@it).to have(1).error_on(:last_name)
      end
    end

    context "#gender" do
      it "validates presence" do
        @it.gender = nil
        expect(@it).to have(1).error_on(:gender)
      end

      it "validates inclusion" do
        @it.gender = "bla"
        expect(@it).to have(1).error_on(:gender)
      end
    end

    context "#year_of_birth" do
      it "validates presence" do
        @it.year_of_birth = nil
        expect(@it).to have(1).error_on(:year_of_birth)
      end

      it "validates numericality" do
        @it.year_of_birth = "bla"
        expect(@it).to have(1).error_on(:year_of_birth)
      end
    end

    context "#school_key" do
      before do
        @it.school_id = nil
      end

      it "validates presence" do
        @it.school_key = nil
        expect(@it).to have(1).error_on(:school_key)
      end

      it "validates inclusion" do
        @it.school_key = "secret"
        expect(@it).to have(1).error_on(:school_key)
      end
    end
  end
end
