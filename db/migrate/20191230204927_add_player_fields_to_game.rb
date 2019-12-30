class AddPlayerFieldsToGame < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :p1_id, :integer
    add_column :games, :p2_id, :integer
    remove_column :games,:first_move_id
  end
end
