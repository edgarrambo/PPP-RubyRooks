require 'rails_helper'

RSpec.describe Bishop, type: :model do
  context 'Creation test' do
    it 'instantiates a bishop' do
      game = create :game
      bishop = Bishop.new
      byebug
      expect(bishop.save).to eq true
    end
  end
end
