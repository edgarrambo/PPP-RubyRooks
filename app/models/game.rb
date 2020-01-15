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

  def randomly_assign_player_one_and_player_two(current_user)
    other_player = creating_user
    if rand(1..1000) <= 500
      update(p1_id: other_player.id, p2_id: current_user.id)
    else
      update(p1_id: current_user.id, p2_id: other_player.id)
    end
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
    write_attribute(:p1_id,u.id)
  end

  def player_two=(u)
    write_attribute(:p2_id,u.id)
  end

  def get_player_one 
    return (not player_one.nil?) ? player_one.email : "No Player One"
  end

  def get_player_two
    return (not player_two.nil?) ? player_two.email : "No Player Two"
  end

  def check?
    kings = pieces.where(type: 'King')
    kings.any? { |king| pieces.any? { |piece| piece.can_take?(king) } }
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
end
