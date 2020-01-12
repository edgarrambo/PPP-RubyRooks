# frozen_string_literal: true

class Bishop < Piece
  def valid_move?(new_x, new_y)
    return false if is_obstructed?(new_x, new_y)
    
    x_distance = (new_x - x_position).abs
    y_distance = (new_y - y_position).abs

    x_distance == y_distance
  end
end
