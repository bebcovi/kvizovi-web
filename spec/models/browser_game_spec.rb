require "spec_helper_lite"
require_relative "../../app/models/browser_game"

describe BrowserGame do
  before(:all) do
    class Quiz;     end
    class Student;  end
    class Question; end
    class Game;     end
  end

  before(:each) do
    @browser_game = double(quiz_id: 1)
    Quiz.stub(:find)     {|id| double(id: id, question_ids: [1, 2, 3, 4]) }
    Student.stub(:find)  {|id| double(id: id) }
    Question.stub(:find) {|id| double(id: id, correct_answer?: true).tap { |q| q.stub(:randomize!) { q } } }
    Game.stub(:create!)  {|hash| double(id: 1) }
  end

  context "1 player" do
    before(:each) do
      @browser_game = double(quiz_id: 1, players: [double(id: 1)])
      @it = BrowserGame.new({}).create!(@browser_game)
    end
    subject { @it }

    describe "action methods" do
      it "is initialized with a question" do
        [1, 2, 3, 4].should include(@it.current_question.id)
      end

      it "keeps the one and only player" do
        @it.current_player.id.should eq(1)
        @it.switch_player!
        @it.current_player.id.should eq(1)
      end

      it "comes to each question only once" do
        question_ids = [1, 2, 3, 4]

        question_ids.delete(@it.current_question.id).should_not be_nil
        while question_ids.any?
          @it.next_question!
          question_ids.delete(@it.current_question.id).should_not be_nil
        end

        @it.should be_finished
      end
    end

    describe "helper methods" do
      it "knows how many questions are left" do
        @it.questions_left.should eq(3)
        2.downto(0) do |count|
          @it.next_question!
          @it.questions_left.should eq(count)
        end
      end

      it "knows the current question" do
        question_ids = [1, 2, 3, 4]

        question_ids.delete(@it.current_question.id).should_not be_nil
        while question_ids.any?
          @it.next_question!
          question_ids.delete(@it.current_question.id).should_not be_nil
        end
      end

      it "knows the question number" do
        @it.current_question_number.should eq(1)
        2.upto(4).each do |number|
          @it.next_question!
          @it.current_question_number.should eq(number)
        end
      end

      its(:questions_count) { should eq(4) }

      it "knows when it's finished" do
        2.upto(4).each do |number|
          @it.should_not be_finished
          @it.next_question!
        end

        @it.should be_finished
      end

      it "knows the current player" do
        @it.current_player.id.should eq(1)
      end

      it "knows the current player number" do
        @it.current_player_number.should eq(1)
      end

      it "knows the quiz" do
        @it.quiz.id.should eq(1)
      end
    end
  end

  after(:all) do
    Object.send(:remove_const, :Quiz)     unless defined?(Rails)
    Object.send(:remove_const, :Student)  unless defined?(Rails)
    Object.send(:remove_const, :Question) unless defined?(Rails)
    Object.send(:remove_const, :Game)     unless defined?(Rails)
  end
end
