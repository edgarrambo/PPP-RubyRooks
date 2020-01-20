class Move < ApplicationRecord
  belongs_to :user
  belongs_to :game
  belongs_to :piece

end
