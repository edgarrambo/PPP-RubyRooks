require 'rails_helper'

RSpec.describe Rook, type: :model do

 describe 'valid_move? for the rook' do
    before(:each) do
      @rook = create(:rook, x_position: 2, y_position: 2)
    end
    it 'allows the rook to move multiple squares horizontally' do
      expect(@rook.valid_move?(7,2)).to be true
    end
    it 'allows the rook to move multiple squares vertically' do
      expect(@rook.valid_move?(2,4)).to be true
    end
    it 'should not allow the rook to move multiple squares diagonally' do
      expect(@rook.valid_move?(1,1)).to be false
    end
  end
end
