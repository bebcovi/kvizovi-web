class RenameGamesToPlayedGames < ActiveRecord::Migration
  def up
    rename_table :games, :played_games
  end

  def down
    rename_table :played_games, :games
  end
end
