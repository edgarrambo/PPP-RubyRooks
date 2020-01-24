# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Surrendering a Game', type: :feature do
  feature 'game#surrender' do
    scenario 'player1 surrenders a 2-player game' do
      player1 = create(:user)
      player2 = create(:user)
      game = create(:game, name: 'Testerroni Pizza',
        p1_id: player1.id, p2_id: player2.id,
        creating_user_id: player1.id, invited_user_id: player2.id)
      game.populate_game
      sign_in player1

      visit game_path(game)
      expect(page).to have_content 'Testerroni Pizza'
      click_on 'Surrender'
      game.reload
      expect(game.winner_id).to eq game.p2_id
      expect(game.state).to eq 'Surrendered'
    end

    scenario 'player2 surrenders a 2-player game' do
      player1 = create(:user)
      player2 = create(:user)
      game = create(:game, name: 'Testerroni Pizza',
        p1_id: player1.id, p2_id: player2.id,
        creating_user_id: player1.id, invited_user_id: player2.id)
      game.populate_game
      sign_in player2

      visit game_path(game)
      expect(page).to have_content 'Testerroni Pizza'
      click_on 'Surrender'
      game.reload
      expect(game.winner_id).to eq game.p1_id
      expect(game.state).to eq 'Surrendered'
    end

    scenario 'surrender button does not show after game is surrendered' do
      player1 = create(:user)
      player2 = create(:user)
      game = create(:game, name: 'Testerroni Pizza',
        p1_id: player1.id, p2_id: player2.id,
        creating_user_id: player1.id, invited_user_id: player2.id)
      game.populate_game
      sign_in player2

      visit game_path(game)
      click_on 'Surrender'
      game.reload
      expect(page).not_to have_content 'Surrender'
    end
  end
end
