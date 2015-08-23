class AddFieldsToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :description, :text
    add_column :transactions, :currency, :string
    add_column :transactions, :acc_date, :datetime
  end
end
