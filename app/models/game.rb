# frozen_string_literal: true

class Game < ApplicationRecord
  belongs_to :creating_user, :class_name => 'User', :foreign_key => 'creating_user_id'
  belongs_to :invited_user, :class_name => 'User', :foreign_key => 'invited_user_id', optional: true
  belongs_to :winner, :class_name => 'User', :foreign_key => 'winner_id', optional: true
  has_many :moves, dependent: :destroy 
  has_many :comments, dependent: :destroy
  has_many :pieces, dependent: :destroy
  before_create :assign_default_player
  scope :available, -> { where(invited_user_id: nil) }

  def assign_default_player
    write_attribute(:p1_id, creating_user.id)
  end

  def randomly_assign_players(current_user)
    other_player = creating_user
    if rand(1..1000) <= 500
      update(p1_id: other_player.id, p2_id: current_user.id)
    else
      update(p1_id: current_user.id, p2_id: other_player.id)
    end
  end

  def opponent(current_user)
    current_user.id == p1_id ? player_two : player_one
  end

  def player_one
    return nil if p1_id.nil?
    return User.find(p1_id)
  end

  def player_two
    return nil if p2_id.nil?
    return User.find(p2_id)
  end

  def player_one=(u)
    write_attribute(:p1_id, u.id)
  end

  def player_two=(u)
    write_attribute(:p2_id, u.id)
  end

  def get_player_one 
    return (not player_one.nil?) ? player_one.email : "No Player One"
  end

  def get_player_two
    return (not player_two.nil?) ? player_two.email : "No Player Two"
  end

  def get_enemies(piece)
    return piece.game.pieces.where('piece_number > 5') if piece.is_white?

    piece.game.pieces.where('piece_number < 6')
  end

  def check?(white)
    king = pieces_for_color(white).select { |piece| piece.type == 'King' }.first
    return false unless king

    enemies = get_enemies(king)
    enemies.any? { |enemy| enemy.can_take?(king) }
  end

  def pieces_for_color(white)
    pieces.select { |piece| piece.is_white? == white }
  end

  def populate_game
    # White Rooks
    pieces.create(x_position: 0, y_position: 0, piece_number: 0, type: 'Rook')
    pieces.create(x_position: 0, y_position: 7, piece_number: 0, type: 'Rook')
    # White Knights
    pieces.create(x_position: 0, y_position: 1, piece_number: 1, type: 'Knight')
    pieces.create(x_position: 0, y_position: 6, piece_number: 1, type: 'Knight')
    # White Bishops
    pieces.create(x_position: 0, y_position: 2, piece_number: 2, type: 'Bishop')
    pieces.create(x_position: 0, y_position: 5, piece_number: 2, type: 'Bishop')
    # White Queen
    pieces.create(x_position: 0, y_position: 3, piece_number: 3, type: 'Queen')
    # White King
    pieces.create(x_position: 0, y_position: 4, piece_number: 4, type: 'King')
    # White Pawns
    8.times do |y|
      pieces.create(x_position: 1, y_position: y, piece_number: 5, type: 'Pawn')
    end
    # Black Rooks
    pieces.create(x_position: 7, y_position: 0, piece_number: 6, type: 'Rook')
    pieces.create(x_position: 7, y_position: 7, piece_number: 6, type: 'Rook')
    # Black Knights
    pieces.create(x_position: 7, y_position: 1, piece_number: 7, type: 'Knight')
    pieces.create(x_position: 7, y_position: 6, piece_number: 7, type: 'Knight')
    # Black Bishops
    pieces.create(x_position: 7, y_position: 2, piece_number: 8, type: 'Bishop')
    pieces.create(x_position: 7, y_position: 5, piece_number: 8, type: 'Bishop')
    # Black Queen
    pieces.create(x_position: 7, y_position: 3, piece_number: 9, type: 'Queen')
    # Black King
    pieces.create(x_position: 7, y_position: 4, piece_number: 10, type: 'King')
    # Black Pawns
    8.times do |y|
      pieces.create(x_position: 6, y_position: y, piece_number: 11, type: 'Pawn')
    end
  end

  def can_claim_draw?(current_user)
    return true if stalemate?(current_user)
    return true if threefold_repetition?
    return true if fifty_move_rule?
    return false
  end

  def stalemate?(current_user)
    return false if state == 'Black King in Check.'
    return false if state == 'White King in Check.'
    if current_user.id == p1_id
      white_king = pieces.where(piece_number: 4).first
      white_king_x = white_king.x_position
      white_king_y = white_king.y_position
      opponent_pieces = pieces.where('piece_number > 5')
      if white_king_x == 0
        white_king_possible_x = [0, 1]
      elsif white_king_x == 7
        white_king_possible_x = [6, 7]
      else
        white_king_possible_x = [white_king_x - 1, white_king_x, white_king_x + 1]
      end
      if white_king_y == 0
        white_king_possible_y = [0, 1]
      elsif white_king_y == 7
        white_king_possible_y = [6, 7]
      else
        white_king_possible_y = [white_king_y - 1, white_king_y, white_king_y + 1]
      end
      white_king_possible_x.each do |x|
        white_king_possible_y.each do |y|
          next if x == white_king_x && y == white_king_y
          return false if !white_king.puts_self_in_check?(x, y)
        end
      end
      return true
    elsif current_user.id == p2_id
      black_king = pieces.where(piece_number: 10).first
      black_king_x = black_king.x_position
      black_king_y = black_king.y_position
      opponent_pieces = pieces.where('piece_number < 6')
      if black_king_x == 0
        black_king_possible_x = [0, 1]
      elsif black_king_x == 7
        black_king_possible_x = [6, 7]
      else
        black_king_possible_x = [black_king_x - 1, black_king_x, black_king_x + 1]
      end
      if black_king_y == 0
        black_king_possible_y = [0, 1]
      elsif black_king_y == 7
        black_king_possible_y = [6, 7]
      else
        black_king_possible_y = [black_king_y - 1, black_king_y, black_king_y + 1]
      end
      black_king_possible_x.each do |x|
        black_king_possible_y.each do |y|
          next if x == black_king_x && y == black_king_y
          return false if !black_king.puts_self_in_check?(x, y)
        end
      end
      return true
    else
      return false
    end

  end

  def threefold_repetition? # This one has me beat for now
    return false
  end

  def fifty_move_rule?
    return false if moves.count <= 100
    # The limit is 100 since a move in our app is only one player but in chess is for each player
    last_fifty_moves = moves.order(updated_at: :desc).limit(100) 
    last_fifty_moves.each do |move|
      return false if move.start_piece == 5 || move.start_piece == 11
    end
    last_white_player_capture = pieces.where(x_position: 8).order('updated_at').last
    last_black_player_capture = pieces.where(x_position: 9).order('updated_at').last
    if last_white_player_capture && last_black_player_capture
      return false if last_fifty_moves.last.updated_at < last_white_player_capture.updated_at 
      return false if last_fifty_moves.last.updated_at < last_black_player_capture.updated_at
      return true
    end
    if last_white_player_capture 
      return false if last_fifty_moves.last.updated_at < last_white_player_capture.updated_at
      return true
    end
    if last_black_player_capture
      return false if last_fifty_moves.last.updated_at < last_black_player_capture.updated_at
      return true
    end
    return true 
  end
end
