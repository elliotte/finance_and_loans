class AddVatToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :vat, :decimal, :default => 0.00
  end
end
