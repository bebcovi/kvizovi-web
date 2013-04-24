require "spec_helper"

describe School do
  before do
    @it = Factory.build(:school)
  end

  context "validations" do
    context "#username" do
      it "validates presence" do
        @it.username = nil
        expect(@it).to have(1).error_on(:username)
      end

      it "validates uniqueness" do
        Factory.create(:school, username: "jon")
        @it.username = "jon"
        expect(@it).to have(1).error_on(:username)
      end
    end

    context "#password" do
      it "validates presence" do
        @it.password = nil
        expect(@it).to have(1).error_on(:password)
      end
    end

    context "#email" do
      it "validates presence" do
        @it.email = nil
        expect(@it).to have(1).error_on(:email)
      end

      it "validates uniqueness" do
        Factory.create(:school, email: "jon@snow.com")
        @it.email = "jon@snow.com"
        expect(@it).to have(1).error_on(:email)
      end
    end

    context "#place" do
      it "validates presence" do
        @it.place = nil
        expect(@it).to have(1).error_on(:place)
      end
    end

    context "#region" do
      it "validates presence" do
        @it.region = nil
        expect(@it).to have(1).error_on(:region)
      end
    end

    context "#level" do
      it "validates presence" do
        @it.level = nil
        expect(@it).to have(1).error_on(:level)
      end

      it "validates inclusion" do
        @it.level = "bla"
        expect(@it).to have(1).error_on(:level)
      end
    end

    context "#key" do
      it "validates presence" do
        @it.key = nil
        expect(@it).to have(1).error_on(:key)
      end
    end
  end
end
