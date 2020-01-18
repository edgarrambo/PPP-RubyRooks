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
end
