require 'rails_helper'

RSpec.describe PiecesController, type: :controller do
  describe 'pieces#update action' do
    it 'updates a pieces location' do
      user = create(:user)
      sign_in user
      game = create(:game)
  
      piece = create(:piece, x_position: 2, y_position: 4, game_id: game.id, piece: 4)
piece.update_attributes(x_position: 4, y_position: 7, game_id: game.id, piece: 4)
    
    patch :update, params: {
        id: piece.id,
        game_id: game.id,
        piece: {
          x_position: 4,
          y_position: 7,
          piece: 4
        }
      }
     
      expect(response).to redirect_to game_path(game.id)
      expect(piece.x_position).to eq 4
      expect(piece.y_position).to eq 7

    end
  end
end
