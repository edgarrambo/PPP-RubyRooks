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
      expect(piece_two.x_position).to eq 8
      expect(piece_two.y_position).to eq 0
    end

    it 'updates moving piece(black) position and occupying piece(white) position if they are different colors' do
      piece_one = create(:piece, x_position: 1, y_position: 1, piece_number: 7, game_id: @game.id)
      piece_two = create(:piece, x_position: 3, y_position: 3, piece_number: 1, game_id: @game.id)

      piece_one.move_to!(3, 3)
      piece_two.reload

      expect(piece_one.x_position).to eq 3
      expect(piece_one.y_position).to eq 3
      expect(piece_two.x_position).to eq 9
      expect(piece_two.y_position).to eq 0
    end

    it 'updates position if there is no occupying piece' do
      piece = create(:piece, x_position: 1, y_position: 1, piece_number: 0, game_id: @game.id)

      piece.move_to!(4, 4)

      expect(piece.x_position).to eq 4
      expect(piece.y_position).to eq 4
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

  describe 'puts_game_in_check?(x, y)' do
    it 'prevents putting yourself in check' do
      game = create(:game)
      king = create(:king, piece_number: 4, x_position: 3, y_position: 3, game_id: game.id)
      create(:rook, piece_number: 11, x_position: 4, y_position: 4, game_id: game.id)

      expect(king.puts_game_in_check?(3, 4)).to eq true
      expect(king.puts_game_in_check?(2, 2)).to eq false
    end

    it 'blocks check with another piece' do
      game = create(:game)
      king = create(:king, piece_number: 4, x_position: 2, y_position: 4, game_id: game.id)
      knight = create(:knight, piece_number: 1, x_position: 3, y_position: 4, game_id: game.id)
      create(:rook, piece_number: 11, x_position: 4, y_position: 4, game_id: game.id)

      expect(king.puts_game_in_check?(1, 4)).to eq false
      expect(knight.puts_game_in_check?(4, 2)).to eq true
    end

    it 'puts into check by moving another piece out of the way' do
      game = create(:game)
      king = create(:king, piece_number: 4, x_position: 2, y_position: 4, game_id: game.id)
      knight = create(:knight, piece_number: 1, x_position: 3, y_position: 4, game_id: game.id)
      create(:rook, piece_number: 11, x_position: 4, y_position: 4, game_id: game.id)

      expect(knight.puts_game_in_check?(4, 2)).to eq true
    end

    it 'ensures coordiantes for pieces are not affected by would be in check' do
      game = create(:game)
      king = create(:king, piece_number: 4, x_position: 4, y_position: 4, game_id: game.id)
      create(:rook, piece_number: 11, x_position: 5, y_position: 5, game_id: game.id)

      king_position = [king.x_position, king.y_position]

      expect(king.puts_game_in_check?(5, 4)).to eq true
      expect(king_position).to eq [4, 4]

      expect(king.puts_game_in_check?(3, 3)).to eq false
      expect(king_position).to eq [4, 4]
    end

    it 'ensures move_to!() does not update attributes if pieces move would put game in check' do
      game = create(:game)
      king = create(:king, piece_number: 4, x_position: 4, y_position: 4, game_id: game.id)
      create(:rook, piece_number: 11, x_position: 5, y_position: 5, game_id: game.id)

      king.move_to!(5, 4)
      game.reload

      expect(king.x_position).to eq 4
      expect(king.y_position).to eq 4
    end
  end
end
