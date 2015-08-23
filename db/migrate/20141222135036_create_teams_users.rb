class CreateTeamsUsers < ActiveRecord::Migration
  def change
    create_table :teams_users do |t|
      t.references :user, index: true
      t.references :team, index: true
      t.string :status

      t.timestamps
    end
  end
end
