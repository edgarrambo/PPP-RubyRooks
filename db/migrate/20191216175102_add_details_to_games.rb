class AddDetailsToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :description, :string
    add_column :games, :creating_user_id, :integer
    add_column :games, :invited_user_id, :integer
    add_column :games, :first_move_id, :integer
    add_column :games, :winner_id, :integer

    add_index :games, :creating_user_id
    add_index :games, :invited_user_id
    add_index :games, :first_move_id
    add_index :games, :winner_id
  end
end
