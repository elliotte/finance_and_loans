class AddYearEndToReportsTable < ActiveRecord::Migration
  def change
    add_column :reports, :year_end, :date
  end
end
