require 'rails_helper'

RSpec.describe Queen, type: :model do
  describe 'valid_move? for the queen' do
    before(:each) do
      @queen = create(:queen, x_position: 3, y_position: 4, piece_number: 5)
    end

    it 'allows the queen to move multiple spaces horizontally' do
      excpect(@queen.valid_move(3,5)).to be true
    end
  end
end
