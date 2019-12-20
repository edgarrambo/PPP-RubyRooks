class RemoveGameIdFromPieces < ActiveRecord::Migration[5.2]
  def change
    remove_column :pieces, :game_id
  end
end
