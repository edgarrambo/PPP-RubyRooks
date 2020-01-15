# frozen_string_literal: true
class Pawn < Piece
  
  def valid_move?(x,y)
    dx = x - x_position
    dy = y - y_position
    return false if is_reverse?(x,y)
    return false if is_obstructed?(x,y)
    return true  if diagonal_capture?(x,y)
    return false if dy != 0 # restrict movement along the x-axis
    return true  if can_move_two?(x,y)
    return true  if dx.abs == 1 
    return false
  end

  def is_reverse?(x,y)
    dx = x - x_position
    dy = y - y_position
    return dx < 0 if is_white?
    return dx > 0 if not is_white?
  end

  def diagonal_capture?(x,y)
    dx = x - x_position
    dy = y - y_position
    return false if dy.abs != 1
    if is_white? && dx == 1 || !is_white? && dx == -1
      targets = game.pieces.find do |piece|
        piece.x_position == x && piece.y_position == y
      end
      return targets.present?
    end 
  end

  def can_move_two?(x,y)
    dx = (x - x_position).abs
    dy = (y - y_position).abs
    return dx <= 2 if (is_white? and x_position == 1) or (not is_white? and x_position == 6)
    return false
  end
end