require "spec_helper_lite"
require_relative "../../../app/models/game/game_state"

describe GameState do
  before(:each) { @it = GameState.new({}).initialize!(game_info) }
  subject { @it }

  let(:game_info) do
    {
      player_ids: [34, 12],
      quiz_id: 1,
      question_ids: [23, 14, 2]
    }
  end

  it "works correctly" do
    @it.questions_count.should eq 3
    @it.players_count.should eq 2
    @it.quiz_id.should eq 1

    @it.current_question_number.should eq 1
    @it.current_question_id.should eq 23
    @it.current_player_number.should eq 1
    @it.current_player_id.should eq 34

    @it.save_answer!(true)
    @it.next_question!
    @it.current_question_number.should eq 2
    @it.current_question_id.should eq 14
    @it.current_player_number.should eq 2
    @it.current_player_id.should eq 12

    @it.save_answer!(false)
    @it.next_question!
    @it.current_question_number.should eq 3
    @it.current_question_id.should eq 2
    @it.current_player_number.should eq 1
    @it.current_player_id.should eq 34

    @it.game_finished?.should be_false
    @it.save_answer!(true)
    @it.game_finished?.should be_true

    @it.info.should eq(
      {
        player_ids: [34, 12],
        quiz_id: 1,
        question_ids: [23, 14, 2],
        question_answers: [true, false, true]
      }
    )
  end
end
