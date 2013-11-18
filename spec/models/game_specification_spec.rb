require "spec_helper"

describe GameSpecification do
  subject { described_class.new }

  context "#quiz_id" do
    it "must be present" do
      subject.quiz_id = nil
      expect(subject).to have(1).error_on(:quiz_id)
    end
  end

  context "#players_count" do
    it "must be present" do
      subject.players_count = nil
      expect(subject).to have(1).error_on(:players_count)
    end
  end

  context "#players_credentials" do
    let(:players) { create_list(:student, 2) }

    before do
      subject.players_count = players.count
    end

    it "must belongs to registered players" do
      subject.players_credentials = players.map do |player|
        {username: "foo", password: "bar"}
      end
      expect(subject).to have(1).error_on(:players_credentials)

      subject.players_credentials = players.map do |player|
        {username: player.username, password: player.password}
      end
      expect(subject).to have(0).errors_on(:players_credentials)
    end
  end
end
