# frozen_string_literal: true

module GamesHelper
  include ActionView::Helpers::TagHelper

  def get_piece(x, y, game)
    game.pieces.where(x_position: x, y_position: y).first
  end

  def render_piece(x, y, game, color)
    piece = get_piece(x, y, game)
    tag.h1 piece.piece.to_s, class: color
  end

  def is_black?(x,y)
    return (x % 2 == 0 && y % 2 == 0 || x % 2 == 1 && y % 2 == 1)
  end

  def is_square_for_piece_to_be_moved?(the_piece, piece)
    return the_piece && the_piece == piece
  end
end
