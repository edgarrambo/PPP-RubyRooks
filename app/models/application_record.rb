# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def is_white?
    return piece_number < 6 
  end

  def get_enemies(piece)
    return piece.game.pieces.where('piece_number > 5') if piece.is_white?

    piece.game.pieces.where('piece_number < 6')
  end
end
