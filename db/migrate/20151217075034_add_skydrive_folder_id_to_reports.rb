class AddSkydriveFolderIdToReports < ActiveRecord::Migration
  def change
    add_column :reports, :skydrive_folder, :string
  end
end
