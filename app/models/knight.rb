# frozen_string_literal: true

class Knight < Piece
  def valid_move?(x, y)
    return false if players_own_piece_is_there?(x, y)

    x_distance = (x - x_position).abs
    y_distance = (y - y_position).abs

    x_distance == 1 && y_distance == 2 || x_distance == 2 && y_distance == 1
  end
end
