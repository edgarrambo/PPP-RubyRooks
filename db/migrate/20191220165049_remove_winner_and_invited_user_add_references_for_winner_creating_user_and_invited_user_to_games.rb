class RemoveWinnerAndInvitedUserAddReferencesForWinnerCreatingUserAndInvitedUserToGames < ActiveRecord::Migration[5.2]
  def change
    remove_column :games, :winner_id
    remove_column :games, :invited_user_id
    add_reference :games, :creating_user, index: true
    add_foreign_key :games, :users, column: :creating_user_id, primary_key: :id
    add_reference :games, :invited_user, index: true
    add_foreign_key :games, :users, column: :invited_user_id, primary_key: :id
    add_reference :games, :winner, index: true
    add_foreign_key :games, :users, column: :winner_id, primary_key: :id
  end
end
