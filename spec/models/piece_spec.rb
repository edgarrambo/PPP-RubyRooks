require 'rails_helper'

RSpec.describe Piece, type: :model do
  context 'Validation test' do
    it 'is valid with valid attributes' do
      user = create(:user)
      sign_in user
      expect(create(:piece)).to be_valid
    end
  end

  describe 'piece is_obstructed? method' do
    before(:each) do
      @game = create(:game)
    end

    it 'returns true if obstructed vertically' do
      piece_one = create(:piece, x_position: 0, y_position: 4, game_id: @game.id)
      piece_two = create(:piece, x_position: 0, y_position: 5, game_id: @game.id)

      expect(piece_one.is_obstructed?(0, 6)).to eq true
    end

    it 'returns false if not obstructed vertically' do
      piece_one = create(:piece, x_position: 0, y_position: 4, game_id: @game.id)
      piece_two = create(:piece, x_position: 0, y_position: 7, game_id: @game.id)

      expect(piece_one.is_obstructed?(0, 6)).to eq false
    end

    it 'returns true if obstructed horizontally' do
      piece_one = create(:piece, x_position: 0, y_position: 4, game_id: @game.id)
      piece_two = create(:piece, x_position: 2, y_position: 4, game_id: @game.id)

      expect(piece_one.is_obstructed?(4, 4)).to eq true
    end

    it 'returns false if not obstructed horizontally' do
      piece_one = create(:piece, x_position: 0, y_position: 4, game_id: @game.id)
      piece_two = create(:piece, x_position: 2, y_position: 4, game_id: @game.id)

      expect(piece_one.is_obstructed?(1, 4)).to eq false
    end

    it 'returns true if obstructed diagonally' do
      piece_one = create(:piece, x_position: 1, y_position: 1, game_id: @game.id)
      piece_two = create(:piece, x_position: 2, y_position: 2, game_id: @game.id)

      expect(piece_one.is_obstructed?(3, 3)).to eq true
    end

    it 'returns false if not obstructed diagonally' do
      piece_one = create(:piece, x_position: 1, y_position: 1, game_id: @game.id)
      piece_two = create(:piece, x_position: 3, y_position: 3, game_id: @game.id)

      expect(piece_one.is_obstructed?(2, 2)).to eq false
    end

    it 'returns false if not obstructed diagonally' do
      piece_one = create(:piece, x_position: 1, y_position: 3, game_id: @game.id)
      piece_two = create(:piece, x_position: 3, y_position: 3, game_id: @game.id)
      
      expect(piece_one.is_obstructed?(5, 7)).to eq false
    end

    it 'returns true if destination contains piece of the same color(white)' do
      piece_one = create(:piece, x_position: 1, y_position: 1, piece_number: 5, game_id: @game.id)
      piece_two = create(:piece, x_position: 2, y_position: 2, piece_number: 5, game_id: @game.id)

      expect(piece_one.is_obstructed?(2, 2)).to eq true
    end

    it 'returns true if destination contains piece of the same color(black)' do
      piece_one = create(:piece, x_position: 1, y_position: 1, piece_number: 11, game_id: @game.id)
      piece_two = create(:piece, x_position: 2, y_position: 2, piece_number: 11, game_id: @game.id)

      expect(piece_one.is_obstructed?(2, 2)).to eq true
    end

    it 'returns false if destination contains piece of the opposite color' do
      piece_one = create(:piece, x_position: 1, y_position: 1, piece_number: 5, game_id: @game.id)
      piece_two = create(:piece, x_position: 2, y_position: 2, piece_number: 11, game_id: @game.id)

      expect(piece_one.is_obstructed?(2, 2)).to eq false
    end

    it 'returns true if destination is the original location' do
      piece_one = create(:piece, x_position: 1, y_position: 1, piece_number: 5, game_id: @game.id)

      expect(piece_one.is_obstructed?(1, 1)).to eq true
    end
  end

  describe 'move_to!() method' do
    before(:each) do
      @game = create(:game)
    end

    it 'updates moving piece(white) position and occupying piece(black) position if they are different colors' do
      piece_one = create(:piece, x_position: 1, y_position: 1, piece_number: 1, game_id: @game.id)
      piece_two = create(:piece, x_position: 3, y_position: 3, piece_number: 7, game_id: @game.id)

      piece_one.move_to!(3, 3)
      piece_two.reload

      expect(piece_one.x_position).to eq 3
      expect(piece_one.y_position).to eq 3
      expect(piece_one.moved).to eq true
      expect(piece_two.x_position).to eq 8
      expect(piece_two.y_position).to eq 0
      expect(piece_two.moved).to eq false
    end

    it 'updates moving piece(black) position and occupying piece(white) position if they are different colors' do
      piece_one = create(:piece, x_position: 1, y_position: 1, piece_number: 7, game_id: @game.id)
      piece_two = create(:piece, x_position: 3, y_position: 3, piece_number: 1, game_id: @game.id)

      piece_one.move_to!(3, 3)
      piece_two.reload

      expect(piece_one.x_position).to eq 3
      expect(piece_one.y_position).to eq 3
      expect(piece_one.moved).to eq true
      expect(piece_two.x_position).to eq 9
      expect(piece_two.y_position).to eq 0
      expect(piece_two.moved).to eq false
    end

    it 'updates position if there is no occupying piece' do
      piece = create(:piece, x_position: 1, y_position: 1, piece_number: 0, game_id: @game.id)

      piece.move_to!(4, 4)

      expect(piece.x_position).to eq 4
      expect(piece.y_position).to eq 4
      expect(piece.moved).to eq true
    end
  end

  describe 'can_take? method' do
    before(:each) do
      @game = create(:game)
    end

    it 'checks if a black queen can take a white knight' do
      black_queen = create(:queen, x_position: 3, y_position: 3, piece_number: 10, game_id: @game.id)
      white_knight = create(:knight, x_position: 5, y_position: 5, piece_number: 1, game_id: @game.id)

      expect(black_queen.can_take?(white_knight)).to eq true
    end

    it 'checks if a white knight can take a black queen' do
      black_queen = create(:queen, x_position: 3, y_position: 3, piece_number: 10, game_id: @game.id)
      white_knight = create(:knight, x_position: 4, y_position: 5, piece_number: 1, game_id: @game.id)

      expect(white_knight.can_take?(black_queen)).to eq true
    end

    it 'verifies a white knight cannot take a black queen if invalid move' do
      black_queen = create(:queen, x_position: 3, y_position: 3, piece_number: 10, game_id: @game.id)
      white_knight = create(:knight, x_position: 4, y_position: 4, piece_number: 1, game_id: @game.id)

      expect(white_knight.can_take?(black_queen)).to eq false
    end

    it 'verifies a black queen cannot take a white knight if invalid move' do
      black_queen = create(:queen, x_position: 3, y_position: 3, piece_number: 10, game_id: @game.id)
      white_knight = create(:knight, x_position: 4, y_position: 5, piece_number: 1, game_id: @game.id)

      expect(black_queen.can_take?(white_knight)).to eq false
    end

    it 'verifies a black queen cannot take a black king' do
      black_queen = create(:queen, x_position: 3, y_position: 3, piece_number: 10, game_id: @game.id)
      black_king = create(:king, x_position: 4, y_position: 5, piece_number: 9, game_id: @game.id)

      expect(black_queen.can_take?(black_king)).to eq false
    end

    it 'verifies a white knight cannot take a white bishop' do
      white_bishop = create(:bishop, x_position: 3, y_position: 6, piece_number: 2, game_id: @game.id)
      white_knight = create(:knight, x_position: 4, y_position: 4, piece_number: 1, game_id: @game.id)

      expect(white_knight.can_take?(white_bishop)).to eq false
    end
  end

  describe 'can_castle? method' do
    before(:each) do
      @game = create(:game)
      @white_king = create(:king, x_position: 0, y_position: 4, piece_number: 4, game_id: @game.id)
      @white_queenside_rook = create(:rook, x_position: 0, y_position: 0, piece_number: 0, game_id: @game.id)
      @white_kingside_rook = create(:rook, x_position: 0, y_position: 7, piece_number: 0, game_id: @game.id)
      @black_king = create(:king, x_position: 7, y_position: 4, piece_number: 10, game_id: @game.id)
      @black_queenside_rook = create(:rook, x_position: 7, y_position: 0, piece_number: 6, game_id: @game.id)
      @black_kingside_rook = create(:rook, x_position: 7, y_position: 7, piece_number: 6, game_id: @game.id)
    end

    it 'returns false if rook has moved' do
      @white_queenside_rook.update(moved: true)
      @white_kingside_rook.update(moved: true)
      @black_queenside_rook.update(moved: true)
      @black_kingside_rook.update(moved: true)

      expect(@white_king.can_castle?(@white_queenside_rook)).to eq false
      expect(@white_king.can_castle?(@white_kingside_rook)).to eq false
      expect(@black_king.can_castle?(@black_queenside_rook)).to eq false
      expect(@black_king.can_castle?(@black_kingside_rook)).to eq false
    end

    it 'returns false if the king has moved' do
      @white_king.update(moved: true)
      @black_king.update(moved: true)

      expect(@white_king.can_castle?(@white_queenside_rook)).to eq false
      expect(@white_king.can_castle?(@white_kingside_rook)).to eq false
      expect(@black_king.can_castle?(@black_queenside_rook)).to eq false
      expect(@black_king.can_castle?(@black_kingside_rook)).to eq false
    end

    it 'returns false if their are obstructions' do
      white_knight = create(:knight, x_position: 0, y_position: 1, piece_number: 1, game_id: @game.id)
      white_bishop = create(:bishop, x_position: 0, y_position: 6, piece_number: 2, game_id: @game.id)
      black_knight = create(:knight, x_position: 7, y_position: 2, piece_number: 7, game_id: @game.id)
      black_bishop = create(:bishop, x_position: 7, y_position: 5, piece_number: 8, game_id: @game.id)

      expect(@white_king.can_castle?(@white_queenside_rook)).to eq false
      expect(@white_king.can_castle?(@white_kingside_rook)).to eq false
      expect(@black_king.can_castle?(@black_queenside_rook)).to eq false
      expect(@black_king.can_castle?(@black_kingside_rook)).to eq false
    end

    it 'returns false if the king is in check' do
      white_queen = create(:queen, x_position: 4, y_position: 4, piece_number: 3, game_id: @game.id)
      black_queen = create(:queen, x_position: 3, y_position: 4, piece_number: 9, game_id: @game.id)

      expect(@white_king.can_castle?(@white_queenside_rook)).to eq false
      expect(@white_king.can_castle?(@white_kingside_rook)).to eq false
      expect(@black_king.can_castle?(@black_queenside_rook)).to eq false
      expect(@black_king.can_castle?(@black_kingside_rook)).to eq false
    end

    it 'returns false if the king tries to castle through check' do
      white_queen = create(:queen, x_position: 5, y_position: 5, piece_number: 3, game_id: @game.id)
      black_queen = create(:queen, x_position: 2, y_position: 5, piece_number: 9, game_id: @game.id)

      expect(@white_king.can_castle?(@white_queenside_rook)).to eq false
      expect(@white_king.can_castle?(@white_kingside_rook)).to eq false
      expect(@black_king.can_castle?(@black_queenside_rook)).to eq false
      expect(@black_king.can_castle?(@black_kingside_rook)).to eq false
    end

    it 'returns false if the king would be in check as the result of the move' do
      white_queen = create(:queen, x_position: 3, y_position: 2, piece_number: 3, game_id: @game.id)
      black_queen = create(:queen, x_position: 4, y_position: 6, piece_number: 9, game_id: @game.id)

      expect(@white_king.can_castle?(@white_queenside_rook)).to eq false
      expect(@white_king.can_castle?(@white_kingside_rook)).to eq false
      expect(@black_king.can_castle?(@black_queenside_rook)).to eq false
      expect(@black_king.can_castle?(@black_kingside_rook)).to eq false
    end

    it 'returns true if you can castle' do
      expect(@white_king.can_castle?(@white_queenside_rook)).to eq true
      expect(@white_king.can_castle?(@white_kingside_rook)).to eq true
      expect(@black_king.can_castle?(@black_queenside_rook)).to eq true
      expect(@black_king.can_castle?(@black_kingside_rook)).to eq true
    end

    it 'returns true if opposite rook as moved but castling rook has not' do
      @white_queenside_rook.update(moved: true)
      @black_queenside_rook.update(moved: true)

      expect(@white_king.can_castle?(@white_queenside_rook)).to eq false
      expect(@white_king.can_castle?(@white_kingside_rook)).to eq true
      expect(@black_king.can_castle?(@black_queenside_rook)).to eq false
      expect(@black_king.can_castle?(@black_kingside_rook)).to eq true
    end

    it 'returns true if opposite rook has obstruction but castling rook has not' do
      white_bishop = create(:bishop, x_position: 0, y_position: 6, piece_number: 2, game_id: @game.id)
      black_knight = create(:knight, x_position: 7, y_position: 2, piece_number: 7, game_id: @game.id)

      expect(@white_king.can_castle?(@white_queenside_rook)).to eq true
      expect(@white_king.can_castle?(@white_kingside_rook)).to eq false
      expect(@black_king.can_castle?(@black_queenside_rook)).to eq false
      expect(@black_king.can_castle?(@black_kingside_rook)).to eq true
    end

    it 'returns true if opposite rook causes check but castling rook does not' do
      white_queen = create(:queen, x_position: 6, y_position: 6, piece_number: 3, game_id: @game.id)
      black_queen = create(:queen, x_position: 1, y_position: 2, piece_number: 9, game_id: @game.id)
      
      expect(@white_king.can_castle?(@white_queenside_rook)).to eq false
      expect(@white_king.can_castle?(@white_kingside_rook)).to eq true
      expect(@black_king.can_castle?(@black_queenside_rook)).to eq true
      expect(@black_king.can_castle?(@black_kingside_rook)).to eq false
    end
  end

  describe 'castle! method' do
    before(:each) do
      @game = create(:game)
      @white_king = create(:king, x_position: 0, y_position: 4, piece_number: 4, game_id: @game.id)
      @black_king = create(:king, x_position: 7, y_position: 4, piece_number: 9, game_id: @game.id)
    end

    it 'moves pieces for white player queenside castling' do
      white_queenside_rook = create(:rook, x_position: 0, y_position: 0, piece_number: 0, game_id: @game.id)

      @white_king.castle!(white_queenside_rook)

      @white_king.reload
      white_queenside_rook.reload

      expect(@white_king.x_position).to eq 0
      expect(@white_king.y_position).to eq 2
      expect(@white_king.moved).to eq true
      expect(white_queenside_rook.x_position).to eq 0
      expect(white_queenside_rook.y_position).to eq 3
      expect(white_queenside_rook.moved).to eq true
    end

    it 'moves pieces for white player king side castling' do
      white_kingside_rook = create(:rook, x_position: 0, y_position: 7, piece_number: 0, game_id: @game.id)

      @white_king.castle!(white_kingside_rook)

      @white_king.reload
      white_kingside_rook.reload

      expect(@white_king.x_position).to eq 0
      expect(@white_king.y_position).to eq 6
      expect(@white_king.moved).to eq true
      expect(white_kingside_rook.x_position).to eq 0
      expect(white_kingside_rook.y_position).to eq 5
      expect(white_kingside_rook.moved).to eq true
    end

    it 'moves pieces for black player queen side castling' do
      black_queenside_rook = create(:rook, x_position: 7, y_position: 0, piece_number: 6, game_id: @game.id)

      @black_king.castle!(black_queenside_rook)

      @black_king.reload
      black_queenside_rook.reload

      expect(@black_king.x_position).to eq 7
      expect(@black_king.y_position).to eq 2
      expect(@black_king.moved).to eq true
      expect(black_queenside_rook.x_position).to eq 7
      expect(black_queenside_rook.y_position).to eq 3
      expect(black_queenside_rook.moved).to eq true
    end

    it 'moves pieces for black player king side castling' do
      black_kingside_rook = create(:rook, x_position: 7, y_position: 7, piece_number: 6, game_id: @game.id)

      @black_king.castle!(black_kingside_rook)

      @black_king.reload
      black_kingside_rook.reload

      expect(@black_king.x_position).to eq 7
      expect(@black_king.y_position).to eq 6
      expect(@black_king.moved).to eq true
      expect(black_kingside_rook.x_position).to eq 7
      expect(black_kingside_rook.y_position).to eq 5
      expect(black_kingside_rook.moved).to eq true
    end
  end
end
