class RemoveOmniauthFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :token, :string
    remove_column :users, :expires_at, :integer
    remove_column :users, :expires, :boolean
    remove_column :users, :refresh_token, :string
  end
end
