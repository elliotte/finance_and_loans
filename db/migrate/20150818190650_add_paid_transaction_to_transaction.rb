class AddPaidTransactionToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :paid, :boolean, :default => true
  end
end
