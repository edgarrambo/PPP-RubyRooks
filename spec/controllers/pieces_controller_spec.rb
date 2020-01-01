require 'rails_helper'

RSpec.describe PiecesController, type: :controller do
  describe 'pieces#update action' do
    it 'updates a pieces location' do
      game = create(:game)
      sign_in game.player_one

      piece = create(:piece, game_id: game.id, piece_number: 5, x_position: 1, y_position: 7)

      patch :update, params: { id: piece.id, x_position: 3, y_position: 7 }

      expect(response).to redirect_to game_path(game.id)

      piece.reload

      expect(piece.x_position).to eq 3
      expect(piece.y_position).to eq 7
    end
  end
end
