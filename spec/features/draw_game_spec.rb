# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Claiming a draw in a Game', type: :feature do
  feature 'game#draw' do
    before(:each) do
      @player1 = create(:user)
      @player2 = create(:user)
      @game = create(:game, name: 'Testerroni Pizza',
        p1_id: @player1.id, p2_id: @player2.id,
        creating_user_id: @player1.id, invited_user_id: @player2.id)

      @white_king = create(:king, x_position: 0, y_position: 0, piece_number: 4, game_id: @game.id)
      @black_king = create(:king, x_position: 7, y_position: 7, piece_number: 10, game_id: @game.id)
    end

    scenario 'White player claims a draw' do
      black_rook_1 = create(:rook, x_position: 2, y_position: 1, piece_number: 6, game_id: @game.id)
      black_rook_2 = create(:rook, x_position: 1, y_position: 2, piece_number: 6, game_id: @game.id)

      sign_in @player1
      visit game_path(@game)
      expect(page).to have_content 'Claim a draw'
    end

    scenario 'Black player claims a draw' do
      white_queenside_rook = create(:rook, x_position: 6, y_position: 5, piece_number: 0, game_id: @game.id)
      white_kingside_rook = create(:rook, x_position: 5, y_position: 6, piece_number: 0, game_id: @game.id)
      white_pawn = create(:pawn, x_position: 1, y_position: 0, piece_number: 5, game_id: @game.id)
      white_move = create(:move, game_id: @game.id, piece_id: white_pawn.id, start_piece: 5)
      
      sign_in @player2
      visit game_path(@game) 
      expect(page).to have_content 'Claim a draw'
    end

    scenario 'Button does not show up if it is not possible to claim a draw' do
      visit game_path(@game)
      expect(page).not_to have_content 'Claim a draw'      
    end
  end
end
