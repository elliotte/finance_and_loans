class AddDriveFolderToReports < ActiveRecord::Migration
  def change
    add_column :reports, :drive_folder, :string
  end
end
