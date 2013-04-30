class DeleteAllPlayedGames < ActiveRecord::Migration
  class PlayedGame < ActiveRecord::Base
  end

  def up
    PlayedQuiz.destroy_all
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
