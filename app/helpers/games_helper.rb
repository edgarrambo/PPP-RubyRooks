# frozen_string_literal: true

module GamesHelper
  include ActionView::Helpers::TagHelper

  def get_piece(x, y, game)
    return game.pieces.where(x_position: x, y_position: y).first
  end

  def black_tile?(x,y)
    return (x % 2 == 0 && y % 2 == 0 || x % 2 == 1 && y % 2 == 1)
  end

  def is_square_for_piece_to_be_moved?(the_piece, piece)
    return the_piece && the_piece == piece
  end

  def white_king
    return @game.pieces.where(piece_number: 4).first
  end
  
  def white_queenside_rook
    return @game.pieces.where(x_position: 0, y_position: 0).first
  end

  def white_kingside_rook
    return @game.pieces.where(x_position: 0, y_position: 7).first
  end

  def black_king
    return @game.pieces.where(piece_number: 10).first
  end
  
  def black_queenside_rook
    return @game.pieces.where(x_position: 7, y_position: 0).first
  end

  def black_kingside_rook
    return @game.pieces.where(x_position: 7, y_position: 7).first
  end

  def captured_black_pieces
    return @game.pieces.where(x_position: 8)
  end

  def captured_white_pieces
    return @game.pieces.where(x_position: 9)
  end
end
