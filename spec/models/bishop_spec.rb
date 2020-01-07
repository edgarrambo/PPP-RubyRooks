# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bishop, type: :model do
  before :all do
    @bishop = create(:bishop, x_position: 4, y_position: 4)
  end
  describe 'valid_move?' do   
    context 'valid_moves' do    

      it 'should test if diagonal moves are valid' do
        expect(@bishop.valid_move?(5, 5)).to eq true
      end

      it 'should allow diagonal movements greater than 1' do
        expect(@bishop.valid_move?(6,6)).to eq true
      end

      it 'should not allow horizontal movements' do
        expect(@bishop.valid_move?(6, 4)).to eq false
      end

      it 'should not allow vertical movements' do
        expect(@bishop.valid_move?(4, 6)).to eq false
      end      
    end 
  end
end
