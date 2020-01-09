require 'rails_helper'

RSpec.describe PiecesController, type: :controller do
  describe 'pieces#update action' do
    it 'should require users to be logged in' do
      game = create(:game)
      
      piece = create(:piece, game_id: game.id, piece_number: 5, x_position: 1, y_position: 7)

      patch :update, params: { id: piece.id, x_position: 3, y_position: 7 }
      expect(response).to redirect_to new_user_session_path
    end

    it 'should not allow white players to move black pieces' do
      game = create(:game)
      sign_in game.player_one

      piece = create(:piece, game_id: game.id, piece_number: 11, x_position: 6, y_position: 7)

      patch :update, params: { id: piece.id, x_position: 5, y_position: 7 }

      expect(response).to redirect_to game_path(game.id)

      piece.reload

      expect(flash[:alert]).to eq 'That is not your piece!'
      expect(piece.x_position).to eq 6
      expect(piece.y_position).to eq 7
    end

    it 'allows white players to move white pieces' do
      game = create(:game)
      sign_in game.player_one

      piece = create(:piece, game_id: game.id, piece_number: 5, x_position: 1, y_position: 7, type: 'Pawn')
      
      patch :update, params: { id: piece.id, x_position: 3, y_position: 7 }

      expect(response).to redirect_to game_path(game.id)

      piece.reload

      expect(piece.x_position).to eq 3
      expect(piece.y_position).to eq 7
    end

    it 'should not allow black players to move white pieces' do
      user = create(:user)      
      game = create(:game, player_two: user)
      
      sign_in user

      piece = create(:piece, game_id: game.id, piece_number: 5, x_position: 1, y_position: 7)

      patch :update, params: { id: piece.id, x_position: 3, y_position: 7 }

      expect(response).to redirect_to game_path(game.id)

      piece.reload

      expect(flash[:alert]).to eq 'That is not your piece!'
      expect(piece.x_position).to eq 1
      expect(piece.y_position).to eq 7
    end

    it 'allows black players to move black pieces' do
      user = create(:user)      
      game = create(:game, player_two: user)
      
      sign_in user

      piece = create(:piece, game_id: game.id, piece_number: 11, x_position: 6, y_position: 7, type: 'Pawn')

      patch :update, params: { id: piece.id, x_position: 4, y_position: 7 }

      expect(response).to redirect_to game_path(game.id)

      piece.reload

      expect(piece.x_position).to eq 4
      expect(piece.y_position).to eq 7
    end
  end
end
