class RemoveGameIdFromGames < ActiveRecord::Migration[5.2]
  def change
    remove_column :games, :game_id
  end
end
