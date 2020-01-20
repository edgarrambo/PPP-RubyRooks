class AddPieceIdToMoves < ActiveRecord::Migration[5.2]
  def change
    add_reference :moves, :piece, index: true
  end
end
