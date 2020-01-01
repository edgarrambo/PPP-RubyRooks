# frozen_string_literal: true

class Piece < ApplicationRecord
  belongs_to :game

  def is_obstructed?(x, y)
    x_sorted_array = [x, x_position].sort
    y_sorted_array = [y, y_position].sort

    #if piece is in current position
    if (x == self.x_position) && (y == self.y_position) 
      false

    #Vertical
    elsif y == self.y_position 
      @pieces_in_the_way = []
      self.game.pieces.each do |chess_piece|
        if chess_piece != self
          if (chess_piece.y_position == y) && chess_piece.x_position.between?(x_sorted_array[0], x_sorted_array[1])
            @pieces_in_the_way << chess_piece
          end
        end
      end
      !@pieces_in_the_way.empty?

    #Horizontal
    elsif x == self.x_position 
      @pieces_in_the_way = []
      self.game.pieces.each do |chess_piece|    if chess_piece != self
          if (chess_piece.x_position == x) && chess_piece.y_position.between?(y_sorted_array[0], y_sorted_array[1])
            @pieces_in_the_way << chess_piece
          end
        end
      end
      !@pieces_in_the_way.empty?

    #Diagonal
    elsif (x - self.x_position).abs == (y-self.y_position).abs
      @pieces_in_the_way = self.game.pieces.select do |chess_piece|
        next false if chess_piece == self
        ((x - chess_piece.x_position).abs == (y - chess_piece.y_position).abs) && chess_piece.x_position.between?(x_sorted_array[0], x_sorted_array[1]) && chess_piece.y_position.between?(y_sorted_array[0], y_sorted_array[1])
      end
      !@pieces_in_the_way.empty?

    else
      false
    end
  end

  def move_to!(new_x, new_y)
    # is valid
    # is obstructed

    # Check if a piece is at this position
    if Piece.where(x_position: new_x, y_position: new_y, game_id: self.game.id)[0]
      occupying_piece = Piece.where(x_position: new_x, y_position: new_y, game_id: self.game.id)[0]

      # Check if the piece occupying the space is white(0-5) and the moving piece is black(6-11)
      if occupying_piece.piece_number > 5 && self.piece_number < 6
        occupying_piece.update(x_position: 8, y_position: 0)
        self.update(x_position: new_x, y_position: new_y)

      # Check if the piece occupying the space is black(6-11) and the moving piece is white(0-5)
      elsif occupying_piece.piece_number < 6 && self.piece_number > 5
        occupying_piece.update(x_position: 9, y_position: 0)
        self.update(x_position: new_x, y_position: new_y)
      else
        ActionDispatch::Flash.new(alert: 'You cannot move here.')
      end

    # If no piece in this position, update moving piece position to this position
    else
      self.update(x_position: new_x, y_position: new_y)
    end
  end
end
