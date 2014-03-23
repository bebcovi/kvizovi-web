require "spec_helper"

describe ContactMailer do
  describe ".contact" do
    subject { described_class.contact(sender: sender, message: message) }
    let(:message) { "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur interdum." }
    let(:sender)  { "foo@bar.com" }

    it "puts the message in the body" do
      expect(subject.body).to eq message
    end

    it "puts a part of the message in the subject" do
      expect(subject.subject).to end_with("...")
      expect(message).to include subject.subject.match("...").pre_match
    end

    context "when message is nil" do
      let(:message) { nil }

      it "doesn't blow up" do
        expect(subject.subject).to eq nil
        expect(subject.body).to eq ""
      end
    end

    it "sends the email to appropriate recipients" do
      expect(subject.to).to eq ["janko.marohnic@gmail.com"]
      expect(subject.cc).to eq ["matija.marohnic@gmail.com"]
    end

    it "sets the \"Reply to\" to the person who is contacting" do
      expect(subject.reply_to).to eq ["foo@bar.com"]
    end
  end
end
