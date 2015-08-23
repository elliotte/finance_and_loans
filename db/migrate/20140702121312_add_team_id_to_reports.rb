class AddTeamIdToReports < ActiveRecord::Migration
  def change
    add_column :reports, :team_id, :integer
  end
end
