class RemoveCreatingUserIdInGames < ActiveRecord::Migration[5.2]
  def change
    remove_column :games, :creating_user_id
  end
end
