require 'rails_helper'

RSpec.describe @king, type: :model do
  before :all do
    @king = create(:king, x_position: 4, y_position: 4)
  end
  describe 'valid_move?' do   
    context 'valid_moves' do
      it 'should test if horizontal moves are valid' do      expect(@king.valid_move?(5, 4)).to eq true
      end

      it 'should test if vertical moves are valid' do
        expect(@king.valid_move?(4, 5)).to eq true
      end

      it 'should test if diagonal moves are valid' do
        expect(@king.valid_move?(5, 5)).to eq true
      end

      it 'should not allow horizontal movements greater than 1' do
        expect(@king.valid_move?(6, 4)).to eq false
      end

      it 'should not allow vertical movements greater than 1' do
        expect(@king.valid_move?(4, 6)).to eq false
      end

      it 'should not allow vertical movements greater than 1' do
        expect(@king.valid_move?(4, 2)).to eq false
      end

      it 'should not allow diagonal movements greater than 1' do
        expect(@king.valid_move?(6, 6)).to eq false
      end
    end 
  end
end