require 'rails_helper'

RSpec.describe Bishop, type: :model do
  context 'Validation test' do
    it 'is valid with valid attributes' do
      user = create(:user)
      sign_in user
      game = create(:game)
      expect(create(:bishop, game_id: game.game_id)).to be_valid
    end
  end
end
