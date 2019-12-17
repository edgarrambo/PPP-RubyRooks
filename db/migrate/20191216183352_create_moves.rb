class CreateMoves < ActiveRecord::Migration[5.2]
  def change
    create_table :moves do |t|
      t.integer :game_id
      t.integer :user_id
      t.integer :start_piece, :limit => 2
      t.integer :end_piece, :limit => 2
      t.integer :start_x, :limit => 2
      t.integer :start_y, :limit => 2
      t.integer :end_x, :limit => 2
      t.integer :end_y, :limit => 2
      t.timestamps
    end

    add_index :moves, :game_id
    add_index :moves, :user_id
    add_index :moves, :start_piece
    add_index :moves, [:start_x, :start_y]
    add_index :moves, [:end_x, :end_y]
  end
end
