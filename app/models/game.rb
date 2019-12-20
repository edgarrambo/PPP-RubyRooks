# frozen_string_literal: true

class Game < ApplicationRecord
  has_one :creating_user, :class_name => 'User'
  has_one :invited_user, :class_name => 'User'
  belongs_to :first_move, :class_name => 'User', :foreign_key => 'first_move_id'
  has_one :winner, :class_name => 'User'
  has_many :moves
  has_many :comments
  has_many :pieces

end
