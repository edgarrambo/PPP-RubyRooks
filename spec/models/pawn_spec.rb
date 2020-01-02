require 'rails_helper'

RSpec.describe Pawn, type: :model do
  describe 'valid_move? for the pawn' do
    it 'allows white pawn to move forward one space' do
      piece = create(:pawn, x_position: 1, y_position: 7, piece_number: 5)

      expect(piece.valid_move?(2,7)).to be true
    end

  end
end
