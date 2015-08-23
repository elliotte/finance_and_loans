class AddFieldToUsers < ActiveRecord::Migration
  def change
    add_column :users, :user_admin, :boolean, deafult: false
    add_column :users, :team_admin, :boolean, deafult: false
  end
end
