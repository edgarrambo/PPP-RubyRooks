require 'rails_helper'

RSpec.describe Piece, type: :model do
  context 'Validation test' do
    it 'is valid with valid attributes' do
      user = create(:user)
      sign_in user
      expect(create(:piece)).to be_valid
    end
  end
  describe 'piece is_obstructed? method' do
    it 'returns true if obstructed vertically' do
      user = create(:user)
      sign_in user

      game = create(:game)
      piece_one = create(:piece, x_position: 0, y_position: 4, game_id: game.id)
      piece_two = create(:piece, x_position: 0, y_position: 5, game_id: game.id)

      expect(piece_one.is_obstructed?(0,6)).to eq true
    end

    it 'returns false if not obstructed vertically' do
      user = create(:user)
      sign_in user

      game = create(:game)
      piece_one = create(:piece, x_position: 0, y_position: 4, game_id: game.id)
      piece_two = create(:piece, x_position: 0, y_position: 7, game_id: game.id)

      expect(piece_one.is_obstructed?(0,6)).to eq false
    end

    it 'returns true if obstructed horizontally' do
      user = create(:user)
      sign_in user

      game = create(:game)
      piece_one = create(:piece, x_position: 0, y_position: 4, game_id: game.id)
      piece_two = create(:piece, x_position: 2, y_position: 4, game_id: game.id)

      expect(piece_one.is_obstructed?(4,4)).to eq true
    end

    it 'returns false if not obstructed horizontally' do
      user = create(:user)
      sign_in user

      game = create(:game)
      piece_one = create(:piece, x_position: 0, y_position: 4, game_id: game.id)
      piece_two = create(:piece, x_position: 2, y_position: 4, game_id: game.id)

      expect(piece_one.is_obstructed?(1,4)).to eq false
    end

    it 'returns true if obstructed diagonally' do
      user = create(:user)
      sign_in user

      game = create(:game)
      piece_one = create(:piece, x_position: 1, y_position: 1, game_id: game.id)
      piece_two = create(:piece, x_position: 2, y_position: 2, game_id: game.id)

      expect(piece_one.is_obstructed?(3,3)).to eq true
    end

    it 'returns false if not obstructed diagonally' do
      user = create(:user)
      sign_in user

      game = create(:game)
      piece_one = create(:piece, x_position: 1, y_position: 1, game_id: game.id)
      piece_two = create(:piece, x_position: 3, y_position: 3, game_id: game.id)

      expect(piece_one.is_obstructed?(2,2)).to eq false
    end
  end

end
