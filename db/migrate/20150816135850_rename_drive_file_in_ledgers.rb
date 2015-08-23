class RenameDriveFileInLedgers < ActiveRecord::Migration
  def up
  	rename_column :ledgers, :drive_file, :invoice_template_file_link
  end

  def down
  	rename_column :ledgers, :invoice_template_file_link, :drive_file
  end
end
