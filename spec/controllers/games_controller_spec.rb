# frozen_string_literal: true

require 'rails_helper'
include GamesHelper

RSpec.describe GamesController, type: :controller do
  describe 'games#create action' do
    it 'should require users to be logged in' do
      post :create, params: { game: { name: 'Test' } }
      expect(response).to redirect_to new_user_session_path
    end

    it 'should successfully create a new game with 32 pieces' do
      user = create(:user)
      sign_in user

      post :create, params: {
        game: {
          name: 'Test'
        }
      }

      game = Game.last

      expect(response).to redirect_to game_path(game.id)

      expect(game.name).to eq('Test')
      expect(game.creating_user_id).to eq(user.id)
      expect(game.pieces.count).to eq 32
    end
  end

  describe 'games#update_invited_user action' do
    it 'should require users to be logged in' do
      game = create(:game)

      get :update_invited_user, params: { game_id: game.id }
      expect(response).to redirect_to new_user_session_path
    end

    it 'should successfully update a game with two assigned players' do
      game = create(:game)
      user = create(:user)
      sign_in user

      get :update_invited_user, params: { game_id: game.id }

      expect(response).to redirect_to game_path(game.id)
      game.reload
      players = [game.creating_user, game.invited_user]
      expect([game.player_one, game.player_two]).to match_array players
    end
  end

  describe 'games#draw action' do
    it 'should allow games to end in a draw' do
      player1 = create(:user)
      player2 = create(:user)
      game = create(:game, name: 'Testerroni Pizza',
        p1_id: player1.id, p2_id: player2.id,
        creating_user_id: player1.id, invited_user_id: player2.id)
      sign_in player1

      get :draw, params: {game_id: game.id, format: :js}
      expect(response).to redirect_to game_path(game.id)
      game.reload
      expect(game.state).to eq 'Draw'
    end
  end
end
