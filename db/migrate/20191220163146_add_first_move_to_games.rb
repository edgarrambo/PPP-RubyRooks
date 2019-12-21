class AddFirstMoveToGames < ActiveRecord::Migration[5.2]
  def change
    add_reference :games, :first_move, index: true
    add_foreign_key :games, :users, column: :first_move_id, primary_key: :id
  end
end
