require "spec_helper"

describe Post do
  subject { described_class.new }

  describe "#title" do
    it "must be present" do
      subject.title = nil
      expect(subject).to have(1).error_on(:title)
    end
  end

  describe "#body" do
    it "must be present" do
      subject.body = nil
      expect(subject).to have(1).error_on(:body)
    end
  end

  describe ".not_in" do
    it "returns posts w" do
      post1 = create(:post)
      post2 = create(:post)
      expect(Post.not_in(Post.where(id: post1.id))).to eq [post2]
    end
  end
end
