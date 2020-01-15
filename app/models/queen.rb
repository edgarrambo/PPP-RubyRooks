class Queen < Piece
  def valid_move?(new_x, new_y)
    return false if is_obstructed?(new_x, new_y)
    
    x_distance = (new_x - x_position).abs
    y_distance = (new_y - y_position).abs

    horizontal_check = y_distance >= 1 && x_distance == 0
    vertical_check = x_distance >= 1 && y_distance == 0
    diagonal_check = x_distance == y_distance
    return horizontal_check || vertical_check || diagonal_check
  end
end
