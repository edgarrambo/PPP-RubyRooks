class Queen < Piece
  def valid_move?(x, y)
    return false if is_obstructed?(x, y)
    
    x_distance = (x - x_position).abs
    y_distance = (y - y_position).abs

    horizontal_check = y_distance >= 1 && x_distance == 0
    vertical_check = x_distance >= 1 && y_distance == 0
    diagonal_check = x_distance == y_distance
    return horizontal_check || vertical_check || diagonal_check
  end
end
