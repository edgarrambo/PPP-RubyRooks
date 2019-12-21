class RemoveFirstMoveIdInGames < ActiveRecord::Migration[5.2]
  def change
    remove_column :games, :first_move_id
  end
end
