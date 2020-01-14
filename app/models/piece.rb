# frozen_string_literal: true

class Piece < ApplicationRecord
  belongs_to :game

  def is_obstructed?(new_x, new_y)
    x_sorted_array = [new_x, x_position].sort
    y_sorted_array = [new_y, y_position].sort

    if players_own_piece_is_there?(new_x, new_y)
      return true
    elsif new_x - x_position == 0 then
      return horizontal_obstruction?(new_x, new_y, x_sorted_array, y_sorted_array)
    elsif new_y - y_position == 0 then
      return vertical_obstruction?(new_x, new_y, x_sorted_array, y_sorted_array)
    elsif (new_x - x_position).abs == (new_y - y_position).abs then
      return diagonal_obstruction?(new_x, new_y, x_sorted_array, y_sorted_array)
    else
      return true
    end
  end

  def horizontal_obstruction?(new_x, new_y, x_sorted_array, y_sorted_array)
    obstructions = game.pieces.find do |chess_piece|
      is_on_same_rank = new_x == chess_piece.x_position
      is_between_y = chess_piece.y_position.between?(y_sorted_array[0] + 1, y_sorted_array[1] - 1)
      is_on_same_rank && is_between_y
    end
    return obstructions.present?
  end

  def vertical_obstruction?(new_x, new_y, x_sorted_array, y_sorted_array)
    obstructions = game.pieces.find do |chess_piece|
      is_on_same_file = new_y == chess_piece.y_position
      is_between_x = chess_piece.x_position.between?(x_sorted_array[0] + 1, x_sorted_array[1] - 1)
      is_on_same_file && is_between_x
    end
    return obstructions.present?
  end

  def diagonal_obstruction?(new_x, new_y, x_sorted_array, y_sorted_array)
    obstructions = game.pieces.find do |chess_piece|
      is_eq_abs = (new_x - chess_piece.x_position).abs == (new_y - chess_piece.y_position).abs
      is_between_x = chess_piece.x_position.between?(x_sorted_array[0] + 1, x_sorted_array[1] - 1)
      is_between_y = chess_piece.y_position.between?(y_sorted_array[0] + 1, y_sorted_array[1] - 1)

      is_eq_abs && is_between_x && is_between_y
    end
    return obstructions.present?
  end

  def players_own_piece_is_there?(new_x, new_y)
    occupying_piece = Piece.where(x_position: new_x, y_position: new_y, game_id: game.id)
    if occupying_piece.any? then
      return occupying_piece.first.is_white? == is_white?
    else
      false
    end
  end

  def move_to!(new_x, new_y)
    occupying_piece = Piece.where(x_position: new_x, y_position: new_y, game_id: game.id)
    if occupying_piece.any? then
      occupying_piece.first.set_captured!
      occupying_piece.first.save
    end
    assign_attributes(x_position: new_x, y_position: new_y, moved: true)
    save
  end

  def set_captured! # TODO: Maybe should add a column to table that states whether a piece is captured
    if is_white?
      assign_attributes(x_position: 9, y_position: 0)
    else
      assign_attributes(x_position: 8, y_position: 0)
    end
  end

  def can_take?(piece)
    valid_move?(piece.x_position, piece.y_position) &&
      (is_white? != piece.is_white?)
  end

  def can_castle?(rook)
    x_sorted_array = [rook.x_position, x_position].sort
    y_sorted_array = [rook.y_position, y_position].sort

    if moved? ||
       game.pieces.where(x_position: rook.x_position, y_position: rook.y_position).first.moved? ||
       horizontal_obstruction?(rook.x_position, rook.y_position, x_sorted_array, y_sorted_array) ||
       opponent_pieces.any? { |piece| piece.can_take?(self) } ||
       rook.y_position == 0 && [1, 2].any? { |number| moves_into_check?(x_position, y_position - number) } ||
       rook.y_position == 7 && [1, 2].any? { |number| moves_into_check?(x_position, y_position + number) }
      return false
    end

    return true
  end

  def moves_into_check?(x, y)
    return opponent_pieces.any? { |piece| piece.valid_move?(x, y) }
  end

  def opponent_pieces
    if is_white?
      game.pieces.where('piece_number > 5')
    else
      game.pieces.where('piece_number < 6')
    end
  end

  def castle!(rook_position)

  end
end
