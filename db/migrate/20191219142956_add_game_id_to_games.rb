class AddGameIdToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :game_id, :integer, null: false, default: 0

    add_index :games, :game_id
  end
end
