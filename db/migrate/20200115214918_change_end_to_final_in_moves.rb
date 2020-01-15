class ChangeEndToFinalInMoves < ActiveRecord::Migration[5.2]
  def change
    rename_column :moves, :end_x, :final_x
    rename_column :moves, :end_y, :final_y
  end
end
