class DropJoinTableFromLedgersAndTeams < ActiveRecord::Migration
  def change

  	drop_table :ledgers_teams
  	drop_table :ledgers_users

  end
end
