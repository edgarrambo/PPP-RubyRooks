# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Castling in a Game', type: :feature do
  feature 'pieces#castle' do
    before(:each) do
      @player1 = create(:user)
      @player2 = create(:user)
      @game = create(:game, name: 'Testerroni Pizza',
        p1_id: @player1.id, p2_id: @player2.id,
        creating_user_id: @player1.id, invited_user_id: @player2.id)

      @white_king = create(:king, x_position: 0, y_position: 4, piece_number: 4, game_id: @game.id)
      @white_queenside_rook = create(:rook, x_position: 0, y_position: 0, piece_number: 0, game_id: @game.id)
      @white_kingside_rook = create(:rook, x_position: 0, y_position: 7, piece_number: 0, game_id: @game.id)
      @black_king = create(:king, x_position: 7, y_position: 4, piece_number: 10, game_id: @game.id)
      @black_queenside_rook = create(:rook, x_position: 7, y_position: 0, piece_number: 6, game_id: @game.id)
      @black_kingside_rook = create(:rook, x_position: 7, y_position: 7, piece_number: 6, game_id: @game.id)
    end

    scenario 'White player queen side castles' do
      black_pawn = create(:pawn, x_position: 6, y_position: 2, piece_number: 11, game_id: @game.id)
      move = create(:move, game_id: @game.id, piece_id: black_pawn.id, start_piece: 11)

      sign_in @player1
      visit game_path(@game)
      expect(page).to have_content 'White Queen Side Castle'
    end

    scenario 'Black player king side castles' do
      white_pawn = create(:pawn, x_position: 1, y_position: 2, piece_number: 5, game_id: @game.id)
      move = create(:move, game_id: @game.id, piece_id: white_pawn.id, start_piece: 5)

      sign_in @player2
      visit game_path(@game)
      expect(page).to have_content 'Black King Side Castle'
    end

    scenario 'Button does not show up if it is not possible to castle' do
      obstructing_piece = create(:knight, x_position: 0, y_position: 1, piece_number: 1, game_id: @game.id)
      visit game_path(@game)
      expect(page).not_to have_content 'White Queen Side Castle'      
    end
  end
end
