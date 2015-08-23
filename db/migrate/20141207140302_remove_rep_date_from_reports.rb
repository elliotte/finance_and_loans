class RemoveRepDateFromReports < ActiveRecord::Migration
  def change
    remove_column :reports, :rep_date, :date
    add_column :reports, :format, :string
  end
end
