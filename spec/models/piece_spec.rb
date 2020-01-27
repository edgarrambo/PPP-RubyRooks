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

    it 'returns false if not obstructed diagonally but there would be obstructions vertically or horizontally' do
      piece_one = create(:piece, x_position: 4, y_position: 4, game_id: @game.id)
      piece_two = create(:piece, x_position: 4, y_position: 5, game_id: @game.id)
      piece_three = create(:piece, x_position: 4, y_position: 6, game_id: @game.id)
      piece_four = create(:piece, x_position: 5, y_position: 4, game_id: @game.id)
      piece_five = create(:piece, x_position: 6, y_position: 4, game_id: @game.id)
      
      expect(piece_one.is_obstructed?(6, 6)).to eq false
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

    it 'performs En passant' do
      player1 = create(:user)
      player2 = create(:user)
      game = create(:game, name: 'Testerroni Pizza',
        p1_id: player1.id, p2_id: player2.id,
        creating_user_id: player1.id, invited_user_id: player2.id)
      white_pawn = create(:pawn, x_position: 4, y_position: 0, piece_number: 5, game_id: game.id)
      black_pawn = create(:pawn, x_position: 6, y_position: 1, piece_number: 11, game_id: game.id)

      black_pawn.move_to!(4,1)
      game.reload
      white_pawn.move_to!(5,1)
      game.reload
      black_pawn.reload
      expect(white_pawn.x_position).to eq 5
      expect(white_pawn.y_position).to eq 1
      expect(black_pawn.x_position).to eq 8
      expect(black_pawn.y_position).to eq 0
    end

    it 'updates position if there is no occupying piece' do
      piece = create(:piece, x_position: 1, y_position: 1, piece_number: 0, game_id: @game.id)

      piece.move_to!(4, 4)

      expect(piece.x_position).to eq 4
      expect(piece.y_position).to eq 4
      expect(piece.moved).to eq true
      expect(piece.moves.last.final_x).to eq 4
      expect(piece.moves.last.final_y).to eq 4
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


  describe 'puts_self_in_check?(x, y)' do
    it 'prevents putting yourself in check' do
      game = create(:game)
      king = create(:king, piece_number: 4, x_position: 3, y_position: 3, game_id: game.id)
      create(:rook, piece_number: 11, x_position: 4, y_position: 4, game_id: game.id)

      expect(king.puts_self_in_check?(3, 4)).to eq true
      expect(king.puts_self_in_check?(2, 2)).to eq false
    end

    it 'blocks check with another piece' do
      game = create(:game)
      king = create(:king, piece_number: 4, x_position: 2, y_position: 4, game_id: game.id)
      knight = create(:knight, piece_number: 1, x_position: 3, y_position: 4, game_id: game.id)
      create(:rook, piece_number: 11, x_position: 4, y_position: 4, game_id: game.id)

      expect(king.puts_self_in_check?(1, 4)).to eq false
      expect(knight.puts_self_in_check?(4, 2)).to eq true
    end

    it 'puts into check by moving another piece out of the way' do
      game = create(:game)
      king = create(:king, piece_number: 4, x_position: 2, y_position: 4, game_id: game.id)
      knight = create(:knight, piece_number: 1, x_position: 3, y_position: 4, game_id: game.id)
      create(:rook, piece_number: 11, x_position: 4, y_position: 4, game_id: game.id)

      expect(knight.puts_self_in_check?(4, 2)).to eq true
    end

    it 'ensures coordiantes for pieces are not affected by would be in check' do
      game = create(:game)
      king = create(:king, piece_number: 4, x_position: 4, y_position: 4, game_id: game.id)
      create(:rook, piece_number: 11, x_position: 5, y_position: 5, game_id: game.id)

      king_position = [king.x_position, king.y_position]

      expect(king.puts_self_in_check?(5, 4)).to eq true
      expect(king_position).to eq [4, 4]

      expect(king.puts_self_in_check?(3, 3)).to eq false
      expect(king_position).to eq [4, 4]
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

    it 'returns false if it is not the white players turn' do
      white_queen = create(:queen, x_position: 3, y_position: 2, piece_number: 3, game_id: @game.id)
      white_queen.move_to!(6,5)

      @game.reload
      expect(@white_king.can_castle?(@white_queenside_rook)).to eq false
      expect(@white_king.can_castle?(@white_kingside_rook)).to eq false
    end

    it 'returns true if white player can castle' do
      move = create(:move, game_id: @game.id, piece_id: @black_kingside_rook.id)

      expect(@white_king.can_castle?(@white_queenside_rook)).to eq true
      expect(@white_king.can_castle?(@white_kingside_rook)).to eq true      
    end
      
    it 'returns true if black player can castle' do
      white_pawn = create(:pawn, x_position: 1, y_position: 2, piece_number: 5, game_id: @game.id)
      move = create(:move, game_id: @game.id, piece_id: white_pawn.id, start_piece: 5)

      expect(@black_king.can_castle?(@black_queenside_rook)).to eq true
      expect(@black_king.can_castle?(@black_kingside_rook)).to eq true
    end

    it 'returns true if opposite rook has moved but castling rook has not (white players)' do
      @white_queenside_rook.update(moved: true)
      black_pawn = create(:pawn, x_position: 6, y_position: 2, piece_number: 11, game_id: @game.id)
      move = create(:move, game_id: @game.id, piece_id: black_pawn.id, start_piece: 11)

      expect(@white_king.can_castle?(@white_queenside_rook)).to eq false
      expect(@white_king.can_castle?(@white_kingside_rook)).to eq true
      expect(@black_king.can_castle?(@black_queenside_rook)).to eq false
      expect(@black_king.can_castle?(@black_kingside_rook)).to eq false
    end

    it 'returns true if opposite rook has moved but castling rook has not (black players)' do
      @black_queenside_rook.update(moved: true)
      white_pawn = create(:pawn, x_position: 1, y_position: 2, piece_number: 5, game_id: @game.id)
      move = create(:move, game_id: @game.id, piece_id: white_pawn.id, start_piece: 5)

      expect(@white_king.can_castle?(@white_queenside_rook)).to eq false
      expect(@white_king.can_castle?(@white_kingside_rook)).to eq false
      expect(@black_king.can_castle?(@black_queenside_rook)).to eq false
      expect(@black_king.can_castle?(@black_kingside_rook)).to eq true
    end

    it 'returns true if opposite rook has obstruction but castling rook has not (white players)' do
      white_bishop = create(:bishop, x_position: 0, y_position: 6, piece_number: 2, game_id: @game.id)
      black_knight = create(:knight, x_position: 7, y_position: 2, piece_number: 7, game_id: @game.id)
      black_pawn = create(:pawn, x_position: 6, y_position: 2, piece_number: 11, game_id: @game.id)
      move = create(:move, game_id: @game.id, piece_id: black_pawn.id, start_piece: 11)

      expect(@white_king.can_castle?(@white_queenside_rook)).to eq true
      expect(@white_king.can_castle?(@white_kingside_rook)).to eq false
      expect(@black_king.can_castle?(@black_queenside_rook)).to eq false
      expect(@black_king.can_castle?(@black_kingside_rook)).to eq false
    end

    it 'returns true if opposite rook has obstruction but castling rook has not (black players)' do
      white_bishop = create(:bishop, x_position: 0, y_position: 6, piece_number: 2, game_id: @game.id)
      black_knight = create(:knight, x_position: 7, y_position: 2, piece_number: 7, game_id: @game.id)
      white_pawn = create(:pawn, x_position: 1, y_position: 2, piece_number: 5, game_id: @game.id)
      move = create(:move, game_id: @game.id, piece_id: white_pawn.id, start_piece: 5)

      expect(@white_king.can_castle?(@white_queenside_rook)).to eq false
      expect(@white_king.can_castle?(@white_kingside_rook)).to eq false
      expect(@black_king.can_castle?(@black_queenside_rook)).to eq false
      expect(@black_king.can_castle?(@black_kingside_rook)).to eq true
    end

    it 'returns true if opposite rook causes check but castling rook does not (white players)' do
      white_queen = create(:queen, x_position: 6, y_position: 6, piece_number: 3, game_id: @game.id)
      black_queen = create(:queen, x_position: 1, y_position: 2, piece_number: 9, game_id: @game.id)
      black_pawn = create(:pawn, x_position: 6, y_position: 2, piece_number: 11, game_id: @game.id)
      move = create(:move, game_id: @game.id, piece_id: black_pawn.id, start_piece: 11)
      
      expect(@white_king.can_castle?(@white_queenside_rook)).to eq false
      expect(@white_king.can_castle?(@white_kingside_rook)).to eq true
      expect(@black_king.can_castle?(@black_queenside_rook)).to eq false
      expect(@black_king.can_castle?(@black_kingside_rook)).to eq false
    end

    it 'returns true if opposite rook causes check but castling rook does not (black players)' do
      white_queen = create(:queen, x_position: 6, y_position: 6, piece_number: 3, game_id: @game.id)
      black_queen = create(:queen, x_position: 1, y_position: 2, piece_number: 9, game_id: @game.id)
      white_pawn = create(:pawn, x_position: 1, y_position: 2, piece_number: 5, game_id: @game.id)
      move = create(:move, game_id: @game.id, piece_id: white_pawn.id, start_piece: 5)
      
      expect(@white_king.can_castle?(@white_queenside_rook)).to eq false
      expect(@white_king.can_castle?(@white_kingside_rook)).to eq false
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

      expect(@white_king.x_position).to eq 0
      expect(@white_king.y_position).to eq 2
      expect(@white_king.moved).to eq true
      expect(@white_king.moves.last.final_y).to eq 2
      expect(white_queenside_rook.x_position).to eq 0
      expect(white_queenside_rook.y_position).to eq 3
      expect(white_queenside_rook.moved).to eq true
      expect(white_queenside_rook.moves.last.final_y).to eq 3
    end

    it 'moves pieces for white player king side castling' do
      white_kingside_rook = create(:rook, x_position: 0, y_position: 7, piece_number: 0, game_id: @game.id)

      @white_king.castle!(white_kingside_rook)

      expect(@white_king.x_position).to eq 0
      expect(@white_king.y_position).to eq 6
      expect(@white_king.moved).to eq true
      expect(@white_king.moves.last.final_y).to eq 6
      expect(white_kingside_rook.x_position).to eq 0
      expect(white_kingside_rook.y_position).to eq 5
      expect(white_kingside_rook.moved).to eq true
      expect(white_kingside_rook.moves.last.final_y).to eq 5
    end

    it 'moves pieces for black player queen side castling' do
      black_queenside_rook = create(:rook, x_position: 7, y_position: 0, piece_number: 6, game_id: @game.id)

      @black_king.castle!(black_queenside_rook)
      
      expect(@black_king.x_position).to eq 7
      expect(@black_king.y_position).to eq 2
      expect(@black_king.moved).to eq true
      expect(@black_king.moves.last.final_y).to eq 2
      expect(black_queenside_rook.x_position).to eq 7
      expect(black_queenside_rook.y_position).to eq 3
      expect(black_queenside_rook.moved).to eq true
      expect(black_queenside_rook.moves.last.final_y).to eq 3
    end

    it 'moves pieces for black player king side castling' do
      black_kingside_rook = create(:rook, x_position: 7, y_position: 7, piece_number: 6, game_id: @game.id)

      @black_king.castle!(black_kingside_rook)

      expect(@black_king.x_position).to eq 7
      expect(@black_king.y_position).to eq 6
      expect(@black_king.moved).to eq true
      expect(@black_king.moves.last.final_y).to eq 6
      expect(black_kingside_rook.x_position).to eq 7
      expect(black_kingside_rook.y_position).to eq 5
      expect(black_kingside_rook.moved).to eq true
      expect(black_kingside_rook.moves.last.final_y).to eq 5
    end
  end

  describe 'en_passant?(x,y)' do
    before(:each) do
      @player1 = create(:user)
      @player2 = create(:user)
      @game = create(:game, name: 'Testerroni Pizza',
        p1_id: @player1.id, p2_id: @player2.id,
        creating_user_id: @player1.id, invited_user_id: @player2.id)
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

    it 'returns false if it is not a pawn moving to that square' do
      piece = create(:queen, x_position: 5, y_position: 2, piece_number: 9, game_id: @game.id)
      @black_pawn.move_to!(4,1)
      @game.reload
      expect(piece.en_passant?(5,1)).to eq false
    end

    it 'returns true if previous move is a pawn moving two spaces past a pawn' do
      @black_pawn.move_to!(4,1)
      @game.reload
      expect(@white_pawn.en_passant?(5,1)).to eq true
    end
  end

  describe 'fifty_move_rule?' do
    before(:each) do
      @game = create(:game)
      @piece = create(:king, game_id: @game.id, piece_number: 10)
    end

    it 'returns false if no moves exist' do
      expect(@piece.fifty_move_rule?).to eq false
    end

    it 'returns false if less then 100 moves' do
      75.times do 
        move = create(:move, piece_id: @piece.id, game_id: @game.id)
      end
      expect(@piece.fifty_move_rule?).to eq false
    end

    it 'returns false if pawn was moved in the last fifty moves' do
      white_pawn = create(:pawn, game_id: @game.id, piece_number: 5)
      125.times do 
        move = create(:move, piece_id: @piece.id, game_id: @game.id)
      end
      sleep(1.second)
      pawn_move = create(:move, piece_id: white_pawn.id, game_id: @game.id, start_piece: 5)

      75.times do 
        move = create(:move, piece_id: @piece.id, game_id: @game.id)
      end
      
      expect(@piece.fifty_move_rule?).to eq false
    end

    it 'returns false if piece was captured in the last fifty moves' do
      125.times do 
        move = create(:move, piece_id: @piece.id, game_id: @game.id)
      end
      sleep(1.second)
      white_pawn = create(:pawn, game_id: @game.id, piece_number: 5, x_position: 9)

      75.times do 
        move = create(:move, piece_id: @piece.id, game_id: @game.id)
      end
      
      expect(@piece.fifty_move_rule?).to eq false
    end

    it 'returns true if more then 100 moves' do 
      101.times do 
        move = create(:move, piece_id: @piece.id, game_id: @game.id)
      end
      expect(@piece.fifty_move_rule?).to eq true
    end
  end
end
