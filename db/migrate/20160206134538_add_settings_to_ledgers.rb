class AddSettingsToLedgers < ActiveRecord::Migration
  def change
    add_column :ledgers, :cf_settings, :string
  end
end
