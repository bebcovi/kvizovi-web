require "spec_helper"

describe QuizPlay do
  subject { described_class.new({}) }

  before do
    subject.start!(quiz_snapshot, students)
  end

  let(:quiz_snapshot) do
    double(
      id:        0,
      quiz:      double(id: 0),
      questions: 10.times.map { |i| double(id: i, category: "boolean") },
    )
  end

  let(:students) do
    3.times.map { |i| double(id: i) }
  end

  context "actions" do
    describe "#start!" do
      it "stores the begin time" do
        expect(subject.begin_time).to be_present
      end
    end

    describe "#save_answer!" do
      it "saves the answer" do
        answers = subject.questions.map { [true, false].sample }
        answers.each do |answer|
          subject.save_answer!(answer)
          subject.next_question!
        end
        expect(subject.questions.map { |q| q[:answer] }).to eq answers
      end

      it "doesn't save the answer if it's already saved" do
        subject.save_answer!(true)
        subject.save_answer!(false)
        expect(subject.current_question[:answer]).to eq true
      end
    end

    describe "#next_question!" do
      it "goes to the next student" do
        subject.save_answer!(true)
        expect do
          subject.next_question!
        end.to change { subject.current_student[:number] }.by 1
      end

      it "goes to the next question" do
        subject.save_answer!(true)
        expect do
          subject.next_question!
        end.to change { subject.current_question[:number] }.by 1
      end

      it "doesn't go to the next question if the current question wasn't answered" do
        expect do
          subject.next_question!
        end.not_to change { subject.current_question }
      end

      it "doesn't go to the next question if it's on the last question" do
        subject.save_answer!(true)
        until subject.current_question == subject.questions.last
          subject.next_question!
          subject.save_answer!(true)
        end
        expect do
          subject.next_question!
        end.not_to change { subject.current_question }
      end
    end

    describe "#next_student!" do
      it "goes to the next student" do
        expect { subject.next_student! }.to \
          change { subject.current_student[:number] }.from(1).to(2)
        expect { subject.next_student! }.to \
          change { subject.current_student[:number] }.from(2).to(3)
        expect { subject.next_student! }.to \
          change { subject.current_student[:number] }.from(3).to(1)
      end
    end

    describe "#finish!" do
      it "stores the end time" do
        subject.finish!
        expect(subject.end_time).to be_present
      end
    end
  end

  context "reading" do
    describe "#current_question" do
      it "returns the current question" do
        subject.save_answer!(true)
        expect(subject.current_question).to eq({number: 1, id: 0, answer: true, category: "boolean"})
        subject.next_question!
        expect(subject.current_question).to eq({number: 2, id: 1, answer: nil, category: "boolean"})
      end
    end

    describe "#current_student" do
      it "returns the current student" do
        expect(subject.current_student).to eq({number: 1, id: 0})
        subject.next_student!
        expect(subject.current_student).to eq({number: 2, id: 1})
      end
    end

    describe "#quiz" do
      it "returns the quiz" do
        expect(subject.quiz).to eq({id: 0})
      end
    end

    describe "#quiz_snapshot" do
      it "returns the quiz snapshot" do
        expect(subject.quiz_snapshot).to eq({id: 0})
      end
    end

    describe "#begin_time" do
      it "returns a time object" do
        expect(subject.begin_time).to be_a(Time)
      end
    end

    describe "#end_time" do
      it "returns a time object" do
        subject.finish!
        expect(subject.end_time).to be_a(Time)
      end
    end

    describe "#to_h" do
      it "returns a hash of information" do
        subject.finish!
        expect(subject.to_h).to be_a(Hash)
      end
    end

    describe "#interrupted?" do
      it "returns true if the last question wasn't answered" do
        until subject.current_question == subject.questions.last
          subject.save_answer!(true)
          subject.next_question!
        end
        subject.finish!
        expect(subject.interrupted?).to be true
      end

      it "returns false if the last question was answered" do
        subject.save_answer!(true)
        until subject.over?
          subject.next_question!
          subject.save_answer!(true)
        end
        subject.finish!
        expect(subject.interrupted?).to be false
      end
    end

    describe "#over?" do
      it "checks if the quiz play is over" do
        until subject.current_question == subject.questions.last
          subject.save_answer!(true)
          subject.next_question!
        end
        expect(subject.over?).to be false
        subject.save_answer!(true)
        expect(subject.over?).to be true
      end
    end

    context "conversions" do
      context "boolean questions" do
        before { allow(subject).to receive(:question_categories).and_return(["boolean"]) }

        it "handles strings" do
          subject.save_answer!("true")
          expect(subject.current_question[:answer]).to eq true
        end

        it "handles nils" do
          subject.save_answer!(nil)
          expect(subject.current_question[:answer]).to eq Question::NO_ANSWER
        end
      end

      context "choice questions" do
        before { allow(subject).to receive(:question_categories).and_return(["choice"]) }

        it "handles strings" do
          subject.save_answer!("Foo")
          expect(subject.current_question[:answer]).to eq "Foo"
        end

        it "handles nils" do
          subject.save_answer!(nil)
          expect(subject.current_question[:answer]).to eq Question::NO_ANSWER
        end
      end

      context "association questions" do
        before { allow(subject).to receive(:question_categories).and_return(["association"]) }

        it "handles arrays" do
          subject.save_answer!(["Foo", "Foo", "Bar", "Bar"])
          expect(subject.current_question[:answer]).to eq [["Foo", "Foo"], ["Bar", "Bar"]]
        end
      end

      context "text questions" do
        before { allow(subject).to receive(:question_categories).and_return(["text"]) }

        it "handles strings" do
          subject.save_answer!("Foo")
          expect(subject.current_question[:answer]).to eq "Foo"
        end

        it "handles empty strings" do
          subject.save_answer!("")
          expect(subject.current_question[:answer]).to eq Question::NO_ANSWER
        end
      end
    end
  end
end
