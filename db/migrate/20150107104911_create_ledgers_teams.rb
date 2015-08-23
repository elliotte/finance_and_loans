class CreateLedgersTeams < ActiveRecord::Migration
  def change
    create_table :ledgers_teams do |t|
      t.references :ledger
      t.references :team
    end
  end
end
