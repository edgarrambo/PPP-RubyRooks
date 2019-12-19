class CreatePieces < ActiveRecord::Migration[5.2]
  def change
    create_table :pieces do |t|
      t.integer :x_position
      t.integer :y_position
      t.integer :game_id
      t.boolean :black

      t.timestamps

      t.index :game_id
    end
  end
end
