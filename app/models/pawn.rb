# frozen_string_literal: true

class Pawn < Piece

  def valid_move?(x,y)
    is_obstructed?(x, y)
    if (y - y_position).abs == 1
      game.pieces.each do |piece|
        
      end 
    elsif piece_number == 5 and x_position == 1 # Allows two space move on first move of white pawn
      x - x_position == 2 && y - y_position == 0 ||  x - x_position == 1 && y_position - y == 0
    elsif piece_number == 5
      x - x_position == 1 && y - y_position == 0
    else
      false
    end
  end
end
