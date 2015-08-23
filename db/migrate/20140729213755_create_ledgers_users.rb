class CreateLedgersUsers < ActiveRecord::Migration
  def change
    create_table :ledgers_users, id: false do |t|
      t.references :ledger
      t.references :user
    end
    add_index :ledgers_users, [:ledger_id, :user_id]
    add_index :ledgers_users, :user_id
  end
end
