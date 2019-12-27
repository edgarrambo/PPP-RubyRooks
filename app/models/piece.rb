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

end
