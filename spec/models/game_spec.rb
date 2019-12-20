# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game, type: :model do
  context 'Validation test' do
    it 'is valid with valid attributes' do
      user = create(:user)
      sign_in user
      # expect(create(:game)).to be_valid
      expect(create(:game, creating_user: user, invited_user: user, first_move: user, winner: user)).to be_valid
    end
  end
end
