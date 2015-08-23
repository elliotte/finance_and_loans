class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :type
      t.decimal :amount
      t.string :monea_tag
      t.string :mi_tag
      t.references :ledger, index: true

      t.timestamps
    end
  end
end
