class ChangeCfSettingsFormatInLedgers < ActiveRecord::Migration
  def change
  	 change_column :ledgers, :cf_settings,'json USING CAST(cf_settings AS json)'
  end
end
