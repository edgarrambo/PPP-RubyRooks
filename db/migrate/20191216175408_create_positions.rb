class CreatePositions < ActiveRecord::Migration[5.2]
  def change
    create_table :positions do |t|
        t.integer :x_position, :limit => 2
        t.integer :y_position, :limit => 2
        t.integer :piece, :limit => 2
        t.integer :game_id 
      t.timestamps
    end

    add_index :positions, :game_id
  end
end
