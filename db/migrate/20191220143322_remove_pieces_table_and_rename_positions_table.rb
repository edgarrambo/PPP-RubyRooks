class RemovePiecesTableAndRenamePositionsTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :pieces

    rename_table :positions, :pieces
  end
end
