require "spec_helper"

describe School do
  use_nulldb

  before(:each) { @it = build(:school) }
  subject { @it }

  describe "validations" do
    context "#username" do
      it "validates presence" do
        expect { @it.username = nil }.to invalidate(@it)
      end

      it "validate uniqueness" do
        it { should validate_uniqueness_of(:username) }
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

      it "validate uniqueness" do
        it { should validate_uniqueness_of(:email) }
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
    end

    context "#key" do
      it "validates presence" do
        expect { @it.key = nil }.to invalidate(@it)
      end
    end
  end
end
