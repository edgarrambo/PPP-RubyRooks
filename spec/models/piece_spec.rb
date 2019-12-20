require 'rails_helper'

RSpec.describe Piece, type: :model do
  context 'Validation test' do
    it 'is valid with valid attributes' do
      user = create(:user)
      sign_in user
      create(:game)
      expect(create(:piece)).to be_valid
    end
  end
end
