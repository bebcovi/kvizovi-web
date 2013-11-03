require "spec_helper"

describe School do
  subject { described_class.new }

  describe "#username" do
    it "must be present" do
      subject.username = nil
      expect(subject).to have(1).error_on(:username)
    end

    it "must be unique" do
      create(:school, username: "jon")
      subject.username = "jon"
      expect(subject).to have(1).error_on(:username)
    end
  end

  describe "#password" do
    it "must be present" do
      subject.password = nil
      expect(subject).to have(1).error_on(:password)
    end
  end

  describe "#email" do
    it "must be present" do
      subject.email = nil
      expect(subject).to have(1).error_on(:email)
    end

    it "must be unique" do
      create(:school, email: "jon@snow.com")
      subject.email = "jon@snow.com"
      expect(subject).to have(1).error_on(:email)
    end
  end

  describe "#place" do
    it "must be present" do
      subject.place = nil
      expect(subject).to have(1).error_on(:place)
    end
  end

  describe "#region" do
    it "must be present" do
      subject.region = nil
      expect(subject).to have(1).error_on(:region)
    end
  end

  describe "#level" do
    it "must be present" do
      subject.level = nil
      expect(subject).to have(1).error_on(:level)
    end
  end

  describe "#key" do
    it "must be present" do
      subject.key = nil
      expect(subject).to have(1).error_on(:key)
    end
  end
end
