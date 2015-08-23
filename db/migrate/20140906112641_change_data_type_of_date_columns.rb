class ChangeDataTypeOfDateColumns < ActiveRecord::Migration
  def change
    change_column :transactions, :acc_date,  :date
    change_column :values, :repdate,  :date
  end
end
