# frozen_string_literal: true

class Pawn < Piece

  def valid_move?(x,y)
    if is_obstructed?(x, y)
      return false
    end
    
    if diagonal_capture(x, y)
      return true
    end
    
    if y - y_position != 0
      return false
    end

    if white_pawn? and x_position == 1 # Allows two space move on first move of white pawn
      return x - x_position == 2 || x - x_position == 1 
    elsif black_pawn? and x_position == 6 # Allows two space move on first move of black pawn
      return x - x_position == -2 || x - x_position == -1
    elsif white_pawn?
      return x - x_position == 1 
    elsif black_pawn?
      return x - x_position == -1
    else
      return false
    end
  end

  def diagonal_capture(x,y)
    if (y - y_position).abs == 1 && (x - x_position).abs == 1
      targets = game.pieces.find do |piece|
        piece.x_position == x && piece.y_position == y
      end
      return targets.present?
    end 
  end

  def white_pawn?
    return piece_number == 5
  end

  def black_pawn?
    return piece_number == 11
  end
end
