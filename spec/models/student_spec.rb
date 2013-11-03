require "spec_helper"

describe Student do
  subject { described_class.new }

  context "#username" do
    it "must be present" do
      subject.username = nil
      expect(subject).to have(1).error_on(:username)
    end

    it "mustn't contain special characters" do
      subject.username = "@@@"
      expect(subject).to have(1).error_on(:username)
    end

    it "must be longer than 3 characters" do
      subject.username = "ab"
      expect(subject).to have(1).error_on(:username)
    end

    it "must be unique" do
      create(:student, username: "john")
      subject.username = "john"
      expect(subject).to have(1).error_on(:username)
    end
  end

  context "#password" do
    it "must be present" do
      subject.password = nil
      expect(subject).to have(1).error_on(:password)
    end
  end

  context "#grade" do
    it "must be present" do
      subject.grade = nil
      expect(subject).to have(1).error_on(:grade)
    end

    it "must be of appropriate format" do
      subject.grade = "bla"
      expect(subject).to have(1).error_on(:grade)
    end
  end

  context "#first_name" do
    it "must be present" do
      subject.first_name = nil
      expect(subject).to have(1).error_on(:first_name)
    end
  end

  context "#last_name" do
    it "must be present" do
      subject.last_name = nil
      expect(subject).to have(1).error_on(:last_name)
    end
  end

  context "#gender" do
    it "must be present" do
      subject.gender = nil
      expect(subject).to have(1).error_on(:gender)
    end
  end

  context "#year_of_birth" do
    it "must be present" do
      subject.year_of_birth = nil
      expect(subject).to have(1).error_on(:year_of_birth)
    end

    it "must be a number" do
      subject.year_of_birth = "bla"
      expect(subject).to have(1).error_on(:year_of_birth)
    end
  end

  context "#school_key" do
    it "must be present" do
      subject.school_key = nil
      expect(subject).to have(1).error_on(:school_key)
    end

    it "must belong to an existing school" do
      subject.school_key = "secret"
      expect(subject).to have(1).error_on(:school_key)
    end
  end

  context "#email" do
    it "must be present" do
      subject.email = nil
      expect(subject).to have(1).error_on(:email)
    end

    it "must be unique" do
      create(:student, email: "student@example.com")
      subject.email = "student@example.com"
      expect(subject).to have(1).error_on(:email)
    end
  end

  describe "#grade=" do
    it "removes spaces and dots" do
      subject.grade = "4. b"
      expect(subject.grade).to eq "4b"
    end
  end
end
