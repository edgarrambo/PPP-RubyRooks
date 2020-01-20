# frozen_string_literal: true

class Bishop < Piece
  def valid_move?(x, y)
    return false if is_obstructed?(x, y)

    x_distance = (x - x_position).abs
    y_distance = (y - y_position).abs

    x_distance == y_distance
  end
end
