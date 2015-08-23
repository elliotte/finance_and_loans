class DropTeamIdReports < ActiveRecord::Migration
  def change
  	remove_column :reports, :team_id
  end
end
