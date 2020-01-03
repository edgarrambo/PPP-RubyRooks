# frozen_string_literal: true

class Piece < ApplicationRecord
  belongs_to :game
  
  def is_white?
    piece_number < 6
  end

  def is_black?
    piece_number > 5
  end

  def is_obstructed?(x, y)
    x_sorted_array = [x, x_position].sort
    y_sorted_array = [y, y_position].sort

    obstructions = game.pieces.find do |chess_piece|
      next true if has_diagonal_obstruction?(x, y, chess_piece, x_sorted_array, y_sorted_array)
      next true if chess_piece.x_position.between?(x_sorted_array[0] + 1, x_sorted_array[1] - 1)

      chess_piece.y_position.between?(y_sorted_array[0] + 1, y_sorted_array[1] - 1)

    end

    obstructions.present? || players_own_piece_is_there?(x, y) 
    
  end
  
  def has_diagonal_obstruction?(x, y, chess_piece, x_sorted_array, y_sorted_array)
    is_eq_abs = (x - chess_piece.x_position).abs == (y - chess_piece.y_position).abs
    is_between_x = chess_piece.x_position.between?(x_sorted_array[0] + 1, x_sorted_array[1] - 1)
    is_between_y = chess_piece.y_position.between?(y_sorted_array[0] + 1, y_sorted_array[1] - 1)
    return is_eq_abs && is_between_x && is_between_y
  end
  
  def players_own_piece_is_there?(x, y)
    occupying_piece = Piece.where(x_position: x, y_position: y, game_id: game.id)
    if occupying_piece.any? then
      return occupying_piece.first.is_white? && is_white? || occupying_piece.first.is_black? && is_black?
    else
      false
    end
  end

  def move_to!(x,y) 
    occupying_piece = Piece.where(x_position: x, y_position: y, game_id: game.id)
    if occupying_piece.any? then
      occupying_piece.first.set_captured!
      occupying_piece.first.save
    end
    assign_attributes(x_position: x, y_position: y)
    save
  end

  def set_captured! # TODO: Eventually should add a column to table that states whether a piece is captured
    if is_white?
      assign_attributes(x_position: 9, y_position: 0)
    else
      assign_attributes(x_position: 8, y_position: 0)
    end
  end
end