class King < Piece
  def valid_move?(x, y)
    return false if players_own_piece_is_there?(x, y)

    x_distance = (x - x_position).abs
    y_distance = (y - y_position).abs

    if x_distance == 1 && y_distance == 0
      return true
    elsif x_distance == 0 && y_distance == 1
      return true
    elsif x_distance == 1 && y_distance == 1
      return true
    else
      return false
    end
  end
end

  

  