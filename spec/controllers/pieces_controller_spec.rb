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

  describe 'pieces#promotion' do
    it 'promotes a White Pawn to a White Queen' do
      game = create(:game)

      sign_in game.player_one

      white_pawn = create(:pawn, x_position: 7, y_position: 4, piece_number: 5, game_id: game.id)
      expect(white_pawn.promotable?).to eq true

      put :promotion, params: { piece_id: white_pawn.id, id: white_pawn.id, promotion: 'Queen',
                                x_position: white_pawn.x_position, y_position: white_pawn.y_position, format: :js }

      promoted_pawn = Piece.find(white_pawn.id)

      expect(promoted_pawn.type).to eq 'Queen'
      expect(promoted_pawn.id).to eq white_pawn.id
      expect(promoted_pawn.x_position).to eq 7
      expect(promoted_pawn.y_position).to eq 4
      expect(promoted_pawn.piece_number).to eq 3
      expect(promoted_pawn.valid_move?(0, 4)).to eq true
    end

    it 'promotes a White Pawn to a White Rook' do
      game = create(:game)

      sign_in game.player_one

      white_pawn = create(:pawn, x_position: 7, y_position: 4, piece_number: 5, game_id: game.id)
      expect(white_pawn.promotable?).to eq true

      put :promotion, params: { piece_id: white_pawn.id, id: white_pawn.id, promotion: 'Rook',
                                x_position: white_pawn.x_position, y_position: white_pawn.y_position, format: :js }

      promoted_pawn = Piece.find(white_pawn.id)

      expect(promoted_pawn.type).to eq 'Rook'
      expect(promoted_pawn.id).to eq white_pawn.id
      expect(promoted_pawn.x_position).to eq 7
      expect(promoted_pawn.y_position).to eq 4
      expect(promoted_pawn.piece_number).to eq 0
      expect(promoted_pawn.valid_move?(0, 4)).to eq true
    end

    it 'promotes a Black Pawn to a Black Knight' do
      game = create(:game)

      sign_in game.player_one

      black_pawn = create(:pawn, x_position: 0, y_position: 4, piece_number: 11, game_id: game.id)
      expect(black_pawn.promotable?).to eq true

      put :promotion, params: { piece_id: black_pawn.id, id: black_pawn.id, promotion: 'Knight',
                                x_position: black_pawn.x_position, y_position: black_pawn.y_position, format: :js }

      promoted_pawn = Piece.find(black_pawn.id)

      expect(promoted_pawn.type).to eq 'Knight'
      expect(promoted_pawn.id).to eq black_pawn.id
      expect(promoted_pawn.x_position).to eq 0
      expect(promoted_pawn.y_position).to eq 4
      expect(promoted_pawn.piece_number).to eq 7
      expect(promoted_pawn.valid_move?(1, 6)).to eq true
    end

    it 'promotes a Black Pawn to a Black Bishop' do
      game = create(:game)

      sign_in game.player_one

      black_pawn = create(:pawn, x_position: 0, y_position: 4, piece_number: 11, game_id: game.id)
      expect(black_pawn.promotable?).to eq true

      put :promotion, params: { piece_id: black_pawn.id, id: black_pawn.id, promotion: 'Bishop',
                                x_position: black_pawn.x_position, y_position: black_pawn.y_position, format: :js }

      promoted_pawn = Piece.find(black_pawn.id)

      expect(promoted_pawn.type).to eq 'Bishop'
      expect(promoted_pawn.id).to eq black_pawn.id
      expect(promoted_pawn.x_position).to eq 0
      expect(promoted_pawn.y_position).to eq 4
      expect(promoted_pawn.piece_number).to eq 8
      expect(promoted_pawn.valid_move?(3, 7)).to eq true
    end
  end
end
