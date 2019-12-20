require 'rails_helper'

RSpec.describe Piece, type: :model do
  context 'Validation test' do
    it 'is valid with valid attributes' do
      user = create(:user)
      sign_in user
      game = create(:game, creating_user: user, invited_user: user, first_move: user, winner: user)
      expect(create(:piece, game_id: game.id)).to be_valid
    end
  end
end
