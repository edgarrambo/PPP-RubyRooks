class ChangeNameOfPiecesColumnInPiecesTable < ActiveRecord::Migration[5.2]
  def change
    rename_column :pieces, :piece, :piece_number
  end
end
