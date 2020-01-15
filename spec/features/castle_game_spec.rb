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
      sign_in @player1
      visit game_path(@game)
      click_on 'White Queen Side Castle'
      @white_king.reload
      @white_queenside_rook.reload
      expect(@white_king.y_position).to eq 2
      expect(@white_queenside_rook.y_position).to eq 3
    end

    scenario 'Black player king side castles' do
      sign_in @player2
      visit game_path(@game)
      click_on 'Black King Side Castle'
      @black_king.reload
      @black_kingside_rook.reload
      expect(@black_king.y_position).to eq 6
      expect(@black_kingside_rook.y_position).to eq 5
    end

    scenario 'Button does not show up if it is not possible to castle' do
      obstructing_piece = create(:knight, x_position: 0, y_position: 1, piece_number: 1, game_id: @game.id)
      visit game_path(@game)
      expect(page).not_to have_content 'White Queen Side Castle'      
    end
  end
end
