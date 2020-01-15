# frozen_string_literal: true
class Pawn < Piece
  
  def valid_move?(x, y)
    delta_x = x - x_position
    delta_y = y - y_position
    return false if is_reverse?(x, y)
    return false if is_obstructed?(x, y)
    return true  if diagonal_capture?(x, y)
    return true  if en_passant?(x, y)
    return false if delta_y != 0 # restrict movement along the x-axis
    return false if tile_is_occupied?(x, y)
    return true  if can_move_two?(x, y)
    return true  if delta_x.abs == 1 
    return false
  end

  def is_reverse?(x, y)
    delta_x = x - x_position
    delta_y = y - y_position
    return delta_x < 0 if is_white?
    return delta_x > 0 if not is_white?
  end

  def diagonal_capture?(x, y)
    delta_x = x - x_position
    delta_y = y - y_position
    return false if delta_y.abs != 1
    if is_white? && delta_x == 1 || !is_white? && delta_x == -1
      targets = game.pieces.find do |piece|
        piece.x_position == x && piece.y_position == y
      end
      return targets.present?
    end 
  end

  def en_passant?(x, y)
    last_move = game.pieces.order('updated_at').last.moves.order('updated_at').last
    return false if last_move.nil?
    return false if !last_move.pawn?
    return true  if pawn_moved_through_capture(x, y, last_move)
    return false
  end

  def pawn?
    return start_piece == 5 || start_piece == 11
  end

  def pawn_moved_through_capture(x, y, last_move)
    pawn_moved_two = (last_move.start_x - last_move.final_x).abs == 2
    if last_move.is_white?
      return pawn_moved_two && x == 2 && y == last_move.final_y
    elsif !last_move.is_white?
      return pawn_moved_two && x == 5 && y == last_move.final_y
    else
      return false
    end
  end

  def tile_is_occupied?(x, y)
    return opponent_pieces.any? { |piece| piece.x_position == x && piece.y_position == y }
  end

  def can_move_two?(x, y)
    delta_x = (x - x_position).abs
    delta_y = (y - y_position).abs
    return delta_x <= 2 if (is_white? and x_position == 1) or (not is_white? and x_position == 6)
    return false
  end
end