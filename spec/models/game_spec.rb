# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game, type: :model do
  context 'Validation test' do
    it 'is valid with valid attributes' do
      user = FactoryBot.create(:user)
      sign_in user
      expect(create(:game)).to be_valid
    end
  end
end
