class AddMovedToPieces < ActiveRecord::Migration[5.2]
  def change
    add_column :pieces, :moved, :boolean, null: false, default: false
  end
end
