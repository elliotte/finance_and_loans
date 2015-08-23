class DropTeamsUsers < ActiveRecord::Migration
  def change
    drop_table :teams_users
  end

  def down
    create_table :teams_users do |t|
      t.references :user, index: true
      t.references :team, index: true
      t.string :status

      t.timestamps
    end
  end
end
