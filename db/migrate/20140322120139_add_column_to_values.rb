class AddColumnToValues < ActiveRecord::Migration
  def change

  	add_column :values, :type, :string
  	add_column :values, :amount, :decimal

  end
end
