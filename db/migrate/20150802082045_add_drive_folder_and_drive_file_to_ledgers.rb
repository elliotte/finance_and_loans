class AddDriveFolderAndDriveFileToLedgers < ActiveRecord::Migration
  def change
    add_column :ledgers, :drive_folder, :string
    add_column :ledgers, :drive_file, :string
  end
end
