require 'rails_helper'

RSpec.describe Pawn, type: :model do
  describe 'valid_move? for the pawn' do
    before(:each) do
      @game = create(:game)
    end
    context 'tests white pawns' do
      before(:each) do
        @pawn = create(:pawn, x_position: 1, y_position: 7, piece_number: 5, game_id: @game.id)
      end
      it 'allows white pawn to move forward one space' do
        pawn = create(:pawn, x_position: 3, y_position: 7, piece_number: 5, game_id: @game.id)

        expect(pawn.valid_move?(4,7)).to be true
      end

      it 'allows white pawn to move forward two spaces on first move' do
        expect(@pawn.valid_move?(3,7)).to be true
      end

      it 'allows white pawn to move diagonally if a black piece is there' do
        piece = create(:piece, x_position: 2, y_position: 6, piece_number: 8, game_id: @game.id)

        expect(@pawn.valid_move?(2,6)).to be true
      end

      it 'does not allow white pawn to move forward three spaces' do
        pawn = create(:pawn, x_position: 3, y_position: 7, piece_number: 5, game_id: @game.id)

        expect(pawn.valid_move?(6,7)).to be false
      end

      it 'does not allow white pawn to move forward three spaces on first move' do
        expect(@pawn.valid_move?(4,7)).to be false
      end

      it 'does not allow white pawn to move vertically' do
        expect(@pawn.valid_move?(1,6)).to be false
      end

      it 'does not allow white pawn to move diagonally if there is no piece to capture' do
        expect(@pawn.valid_move?(2,6)).to be false
      end

      it 'should not allow moves to tiles occupied with players piece' do
        piece = create(:piece, x_position: 3, y_position: 7, piece_number: 3, game_id: @game.id)

        expect(@pawn.valid_move?(3,7)).to eq false
      end

      it 'should not allow horizontal moves to tiles occupied with opposing players piece' do
        piece = create(:piece, x_position: 3, y_position: 7, piece_number: 11, game_id: @game.id)

        expect(@pawn.valid_move?(3,7)).to eq false
      end

      it 'should not allow moves to original tile' do
        expect(@pawn.valid_move?(1,7)).to eq false
      end

      it 'checks for obstructions' do
        piece = create(:piece, x_position: 2, y_position: 7, piece_number: 8, game_id: @game.id)

        expect(@pawn.valid_move?(3,7)).to be false
      end
    end

    context 'tests black pawns' do
      before(:each) do
        @pawn = create(:pawn, x_position: 6, y_position: 7, piece_number: 11, game_id: @game.id)
      end
      it 'allows black pawn to move forward one space' do
        pawn = create(:pawn, x_position: 4, y_position: 7, piece_number: 11, game_id: @game.id)

        expect(pawn.valid_move?(3,7)).to be true
      end

      it 'allows black pawn to move forward two spaces on first move' do
        expect(@pawn.valid_move?(4,7)).to be true
      end

      it 'allows black pawn to move diagonally if a white piece is there' do
        piece = create(:piece, x_position: 5, y_position: 6, piece_number: 3, game_id: @game.id)

        expect(@pawn.valid_move?(5,6)).to be true
      end

      it 'does not allow black pawn to move forward three spaces' do
        pawn = create(:pawn, x_position: 4, y_position: 7, piece_number: 11, game_id: @game.id)

        expect(pawn.valid_move?(1,7)).to be false
      end

      it 'does not allow black pawn to move forward three spaces on first move' do
        expect(@pawn.valid_move?(3,7)).to be false
      end

      it 'does not allow black pawn to move vertically' do
        expect(@pawn.valid_move?(6,6)).to be false
      end

      it 'does not allow black pawn to move diagonally if there is no piece to capture' do
        expect(@pawn.valid_move?(5,6)).to be false
      end

      it 'should not allow moves to tiles occupied with players piece' do
        piece = create(:piece, x_position: 5, y_position: 6, piece_number: 10, game_id: @game.id)

        expect(@pawn.valid_move?(5,6)).to eq false
      end

      it 'should not allow horizontal moves to tiles occupied with opposing players piece' do
        piece = create(:piece, x_position: 4, y_position: 7, piece_number: 0, game_id: @game.id)

        expect(@pawn.valid_move?(4,7)).to eq false
      end

      it 'should not allow moves to original tile' do
        expect(@pawn.valid_move?(6,7)).to eq false
      end

      it 'checks for obstructions' do
        piece = create(:piece, x_position: 5, y_position: 7, piece_number: 8, game_id: @game.id)

        expect(@pawn.valid_move?(4,7)).to eq false
      end
    end
  end

  describe 'en_passant?(x,y)' do
    before(:each) do
      @game = create(:game)
      @white_pawn = create(:pawn, x_position: 4, y_position: 0, piece_number: 5, game_id: @game.id)
      @black_pawn = create(:pawn, x_position: 6, y_position: 1, piece_number: 11, game_id: @game.id)
    end

    it 'returns false if last piece moved was not a pawn' do
      piece = create(:queen, x_position: 3, y_position: 3, piece_number: 9, game_id: @game.id)
      piece.move_to!(2,3)
      @game.reload
      expect(@white_pawn.en_passant?(5,1)).to eq false
    end

    it 'returns false if last piece moved was a pawn moving one space' do
      @black_pawn.move_to!(5,1)
      @game.reload
      expect(@white_pawn.en_passant?(5,1)).to eq false
    end

    it 'returns false if last piece moved was a pawn moving two spaces on a different row' do
      black_pawn_2 = create(:pawn, x_position: 6, y_position: 7, piece_number: 11, game_id: @game.id)
      black_pawn_2.move_to!(4,7)
      @game.reload
      expect(@white_pawn.en_passant?(5,1)).to eq false
    end

    it 'returns true if previous move is a pawn moving two spaces past a pawn' do
      @black_pawn.move_to!(4,1)
      @game.reload
      @black_pawn.reload
      byebug
      expect(@white_pawn.en_passant?(5,1)).to eq true
    end
  end
end
