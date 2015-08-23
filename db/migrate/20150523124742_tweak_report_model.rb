class TweakReportModel < ActiveRecord::Migration
  def change
	rename_column :reports, :year_end, :current_end
	add_column :reports, :comparative_end, :date
  end
end
