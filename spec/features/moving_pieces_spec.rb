# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Moving pieces', type: :feature do
  feature 'game#update' do
    scenario 'black queen puts white king in check' do
      player1 = create(:user)
      player2 = create(:user)
      game = create(:game, name: 'Example25',
        p1_id: player1.id, p2_id: player2.id,
        creating_user_id: player1.id, invited_user_id: player2.id)
      black_queen = create(:queen, piece_number: 9, x_position: 4, y_position: 4, game_id: game.id)
      white_king = create(:king, piece_number: 4, x_position: 6, y_position: 7, game_id: game.id)

      sign_in player2
      visit game_path(game)
      page.find('#4-4 a').click # Click on Black Queen
      page.find('#6-4 a').click # Drop at this position

      expect(game.check?).to eq true
      expect(page).to have_content 'White King is in Check.'
    end

    scenario 'white king cannot move into check' do
      player1 = create(:user)
      player2 = create(:user)
      game = create(:game, name: 'Example25',
        p1_id: player1.id, p2_id: player2.id,
        creating_user_id: player1.id, invited_user_id: player2.id)
      black_queen = create(:queen, piece_number: 9, x_position: 4, y_position: 4, game_id: game.id)
      white_king = create(:king, piece_number: 4, x_position: 5, y_position: 7, game_id: game.id)

      sign_in player1
      visit game_path(game)
      page.find('#5-7 a').click # Click on White King
      page.find('#4-7 a').click # Drop at this position

      white_king.reload
      expect(white_king.x_position).to eq 5
      expect(game.check?).to eq false
    end
  end
end
