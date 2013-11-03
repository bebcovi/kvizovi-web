require "spec_helper"

describe Student do
  before do
    @it = FactoryGirl.build(:student)
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
        FactoryGirl.build(:student, username: "john").save(validate: false)
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

    context "#email" do
      it "validates presence" do
        @it.email = nil
        expect(@it).to have(1).error_on(:email)
      end

      it "validates uniqueness" do
        FactoryGirl.build(:student, email: "student@example.com").save(validate: false)
        @it.email = "student@example.com"
        expect(@it).to have(1).error_on(:email)
      end
    end
  end

  describe "#grade=" do
    it "removes spaces and dots" do
      @it.grade = "4. b"
      expect(@it.grade).to eq "4b"
    end
  end
end
