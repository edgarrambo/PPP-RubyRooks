# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bishop, type: :model do
  context 'Validation test' do
    it 'is valid with valid attributes' do
      user = create(:user)
      sign_in user
      create(:game)
      expect(create(:bishop)).to be_valid
    end
  end
end
