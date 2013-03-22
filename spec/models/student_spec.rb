require "spec_helper"

describe Student do
  before do
    @it = build(:student)
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
        expect { @it.username = nil }.to invalidate(@it)
      end

      it "validates format" do
        expect { @it.username = "@@@" }.to invalidate(@it)
      end

      it "validates length" do
        expect { @it.username = "ab" }.to invalidate(@it)
        expect { @it.username = "abc" }.to revalidate(@it)
      end

      it "validates uniqueness" do
        expect {
          create(:student, username: "john")
          @it.username = "john"
        }.to invalidate(@it)
      end
    end

    context "#password" do
      it "validates presence" do
        expect { @it.password = nil }.to invalidate(@it)
      end
    end

    context "#grade" do
      it "validates presence" do
        expect { @it.grade = nil }.to invalidate(@it)
      end

      it "validates format" do
        expect { @it.grade = "bla" }.to invalidate(@it)
      end
    end

    context "#first_name" do
      it "validates presence" do
        expect { @it.first_name = nil }.to invalidate(@it)
      end
    end

    context "#last_name" do
      it "validates presence" do
        expect { @it.last_name = nil }.to invalidate(@it)
      end
    end

    context "#gender" do
      it "validates presence" do
        expect { @it.gender = nil }.to invalidate(@it)
      end

      it "validates inclusion" do
        expect { @it.gender = "bla" }.to invalidate(@it)
      end
    end

    context "#year_of_birth" do
      it "validates presence" do
        expect { @it.year_of_birth = nil }.to invalidate(@it)
      end

      it "validates numericality" do
        expect { @it.year_of_birth = "bla" }.to invalidate(@it)
      end
    end

    context "#school_key" do
      it "validates presence" do
        expect {
          @it.school_id = nil
          @it.school_key = nil
        }.to invalidate(@it)
      end

      it "validates existence" do
        @it.school_id = nil
        @it.school_key = "secret"
        create(:school, key: "secret")
        @it.valid?
        puts @it.errors.full_messages

        expect { @it.school_key = "other_secret" }.to invalidate(@it)
      end
    end
  end
end
