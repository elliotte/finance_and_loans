class AddDriversToLedgers < ActiveRecord::Migration
  def change
    add_column :ledgers, :drivers, :json
  end
end
