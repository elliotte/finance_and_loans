class AddOpeningBalanceToLedgers < ActiveRecord::Migration
  def change
    add_column :ledgers, :opening_balance, :decimal
  end
end
