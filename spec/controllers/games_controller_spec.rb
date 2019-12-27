require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe 'games#create action' do
    it 'should require users to be logged in' do
      post :create, params:{ game:{ name: 'Test'}}
      expect(response).to redirect_to new_user_session_path
    end

    it 'should successfully create a new game' do
      user = create(:user)
      sign_in user

      post :create, params: {
        game: {
          name: 'Test',
          creating_user: user
        }
      }

      game = Game.last

      expect(response).to redirect_to game_path(game.id)

      expect(game.name).to eq('Test')
      expect(game.creating_user_id).to eq(user.id)
    end
  end
end
