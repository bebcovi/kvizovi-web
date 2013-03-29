require "spec_helper"

describe School do
  before(:all) do
    @it = build(:school)
  end

  context "validations" do
    reset_attributes(FactoryGirl.attributes_for(:school))

    context "#username" do
      it "validates presence" do
        expect { @it.username = nil }.to invalidate(@it)
      end

      it "validates uniqueness" do
        expect {
          create(:school, username: "jon")
          @it.username = "jon"
        }.to invalidate(@it)
      end
    end

    context "#password" do
      it "validates presence" do
        expect { @it.password = nil }.to invalidate(@it)
      end
    end

    context "#email" do
      it "validates presence" do
        expect { @it.email = nil }.to invalidate(@it)
      end

      it "validates uniqueness" do
        expect {
          create(:school, email: "jon.snow@north.com")
          @it.email = "jon.snow@north.com"
        }.to invalidate(@it)
      end
    end

    context "#place" do
      it "validates presence" do
        expect { @it.place = nil }.to invalidate(@it)
      end
    end

    context "#region" do
      it "validates presence" do
        expect { @it.region = nil }.to invalidate(@it)
      end
    end

    context "#level" do
      it "validates presence" do
        expect { @it.level = nil }.to invalidate(@it)
      end

      it "validates inclusion" do
        expect { @it.level = "bla" }.to invalidate(@it)
      end
    end

    context "#key" do
      it "validates presence" do
        expect { @it.key = nil }.to invalidate(@it)
      end
    end
  end
end
