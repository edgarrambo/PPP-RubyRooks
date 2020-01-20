require 'rails_helper'

RSpec.describe PiecesController, type: :controller do
  describe 'pieces#update action' do
    it 'should require users to be logged in' do
      game = create(:game)

      piece = create(:piece, game_id: game.id, piece_number: 5, x_position: 1, y_position: 7)

      patch :update, params: { id: piece.id, piece: {x_position: 3, y_position: 7}}
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe 'pieces#castle action' do
    it 'allows white player to castle queenside' do
      game = create(:game)

      sign_in game.player_one

      white_king = create(:king, x_position: 0, y_position: 4, piece_number: 4, game_id: game.id)
      white_queenside_rook = create(:rook, x_position: 0, y_position: 0, piece_number: 0, game_id: game.id)

      get :castle, params: { piece_id: white_king.id, rook_id: white_queenside_rook.id}

      expect(response).to redirect_to game_path(game.id)

      white_king.reload
      white_queenside_rook.reload

      expect(white_king.x_position).to eq 0
      expect(white_king.y_position).to eq 2
      expect(white_king.moved).to eq true
      expect(white_queenside_rook.x_position).to eq 0
      expect(white_queenside_rook.y_position).to eq 3
      expect(white_queenside_rook.moved).to eq true
    end
  end
end
