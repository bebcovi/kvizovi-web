require "spec_helper"

describe QuizSpecification do
  subject { described_class.new }

  context "#quiz_id" do
    it "must be present" do
      subject.quiz_id = nil
      expect(subject).to have(1).error_on(:quiz_id)
    end
  end

  context "#students_count" do
    it "must be present" do
      subject.students_count = nil
      expect(subject).to have(1).error_on(:students_count)
    end
  end

  context "#students_credentials" do
    let(:students) { create_list(:student, 2) }

    before do
      subject.students_count = students.count
    end

    it "must belongs to registered students" do
      subject.students_credentials = students.map do |student|
        {username: "foo", password: "bar"}
      end
      expect(subject).to have(1).error_on(:students_credentials)

      subject.students_credentials = students.map do |student|
        {username: student.username, password: student.password}
      end
      expect(subject).to have(0).errors_on(:students_credentials)
    end
  end
end
