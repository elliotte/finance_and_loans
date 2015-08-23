class RemoveIsAdminAndUserAdminFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :is_admin, :boolean
    remove_column :users, :user_admin, :boolean
    remove_column :users, :team_admin, :boolean
  end
end
