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
  
  def populate_game
    # White Rooks
    pieces.create(x_position: 0, y_position: 0, piece: 0)
    pieces.create(x_position: 0, y_position: 7, piece: 0)
    # White Knights
    pieces.create(x_position: 0, y_position: 1, piece: 1)
    pieces.create(x_position: 0, y_position: 6, piece: 1)
    # White Bishops
    pieces.create(x_position: 0, y_position: 2, piece: 2)
    pieces.create(x_position: 0, y_position: 5, piece: 2)
    # White Queen
    pieces.create(x_position: 0, y_position: 3, piece: 3)
    # White King
    pieces.create(x_position: 0, y_position: 4, piece: 4)
    # White Pawns
    8.times do |y|
      pieces.create(x_position: 1, y_position: y, piece: 5)
    end
    # Black Rooks
    pieces.create(x_position: 7, y_position: 0, piece: 6)
    pieces.create(x_position: 7, y_position: 7, piece: 6)
    # Black Knights
    pieces.create(x_position: 7, y_position: 1, piece: 7)
    pieces.create(x_position: 7, y_position: 6, piece: 7)
    # Black Bishops
    pieces.create(x_position: 7, y_position: 2, piece: 8)
    pieces.create(x_position: 7, y_position: 5, piece: 8)
    # Black Queen
    pieces.create(x_position: 7, y_position: 3, piece: 9)
    # Black King
    pieces.create(x_position: 7, y_position: 4, piece: 10)
    # Black Pawns
    8.times do |y|
      pieces.create(x_position: 6, y_position: y, piece: 11)
    end
  end
end
