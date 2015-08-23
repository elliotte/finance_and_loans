class DropTeamCompaniesTables < ActiveRecord::Migration
  def change

  	drop_table :teams
  	drop_table :teams_users
  	drop_table :companies

  end
end
