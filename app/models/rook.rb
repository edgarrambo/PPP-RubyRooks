class Rook < Piece
  def valid_move?(x, y)
    return false if is_obstructed?(x, y)

    x_distance = (x - x_position).abs
    y_distance = (y - y_position).abs

    x_distance >= 1 && y_distance == 0 || y_distance >= 1 && x_distance == 0
  end
end
