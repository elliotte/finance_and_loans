class AddCompanyIdToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :company_id, :integer
  end
end
