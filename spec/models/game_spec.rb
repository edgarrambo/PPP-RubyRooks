# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game, type: :model do
  context 'Validation test' do
    it 'is valid with valid attributes' do
      user = create(:user)
      sign_in user
      expect(create(:game)).to be_valid
    end
  end

  context 'check? method' do
    describe 'white+black king and black+white rook' do
      before(:each) do
        user = create(:user)
        sign_in user
        @game = create(:game)
        @white_king = create(:king, x_position: 0, y_position: 0, piece_number: 3, game_id: @game.id)
        @black_king = create(:king, x_position: 7, y_position: 7, piece_number: 9, game_id: @game.id)
        @black_rook = create(:rook, x_position: 0, y_position: 4, piece_number: 6, game_id: @game.id)
        @white_rook = create(:rook, x_position: 6, y_position: 6, piece_number: 0, game_id: @game.id)
      end

      it 'should have game state in check (white king in check)' do
        expect(@game.check?(true)).to eq true
      end

      it 'should have game state in check (black king in check)' do
        @white_king.update(x_position: 1, y_position: 0)
        @white_rook.update(x_position: 6, y_position: 7)

        expect(@game.check?(false)).to eq true
      end

      it 'should not have game state in check' do
        @black_rook.update(x_position: 1, y_position: 1)
        expect(@game.check?(true)).to eq false
      end

      it 'should be in check with only one King(black) on the board' do
        @white_king.destroy
        @white_rook.update(x_position: 6, y_position: 7)
        expect(@game.check?(false)).to eq true
      end

      it 'should be in check with only one King(white) on the board' do
        @black_king.destroy
        expect(@game.check?(true)).to eq true
      end

      it 'should not be in check with only one King(black) on the board' do
        @white_king.destroy
        expect(@game.check?(true)).to eq false
      end

      it 'should not be in check with only one King(white) on the board' do
        @black_king.destroy
        @black_rook.update(x_position: 4)
        expect(@game.check?(true)).to eq false
      end
    end
  end

  describe 'fifty_move_rule?' do
    before(:each) do
      @game = create(:game)
      @piece = create(:king, game_id: @game.id, piece_number: 10)
    end

    it 'returns false if no moves exist' do
      expect(@game.fifty_move_rule?).to eq false
    end

    it 'returns false if less then 100 moves' do
      75.times do 
        move = create(:move, piece_id: @piece.id, game_id: @game.id)
      end
      expect(@game.fifty_move_rule?).to eq false
    end

    it 'returns false if pawn was moved in the last fifty moves' do
      white_pawn = create(:pawn, game_id: @game.id, piece_number: 5)
      125.times do 
        move = create(:move, piece_id: @piece.id, game_id: @game.id)
      end
      pawn_move = create(:move, piece_id: white_pawn.id, game_id: @game.id, start_piece: 5)

      75.times do 
        move = create(:move, piece_id: @piece.id, game_id: @game.id)
      end
      
      expect(@game.fifty_move_rule?).to eq false
    end

    it 'returns false if piece was captured in the last fifty moves' do
      125.times do 
        move = create(:move, piece_id: @piece.id, game_id: @game.id)
      end
      white_pawn = create(:pawn, game_id: @game.id, piece_number: 5, x_position: 9)

      75.times do 
        move = create(:move, piece_id: @piece.id, game_id: @game.id)
      end
      
      expect(@game.fifty_move_rule?).to eq false
    end

    it 'returns true if more then 100 moves' do 
      white_pawn = create(:pawn, game_id: @game.id, piece_number: 5)
      pawn_move = create(:move, piece_id: white_pawn.id, game_id: @game.id, start_piece: 5)
      white_pawn_captured = create(:pawn, game_id: @game.id, piece_number: 5, x_position: 9)
      101.times do 
        move = create(:move, piece_id: @piece.id, game_id: @game.id)
      end
      expect(@game.fifty_move_rule?).to eq true
    end
  end
end
