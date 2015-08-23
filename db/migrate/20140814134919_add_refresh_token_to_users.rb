class AddRefreshTokenToUsers < ActiveRecord::Migration
  def up
    add_column :users, :refresh_token, :string
  end

  def down
    remove_column :users, :refresh_token
  end
end
