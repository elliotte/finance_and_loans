class DropTeams < ActiveRecord::Migration
  def up
    drop_table :teams
  end

  def down
    create_table :teams do |t|
      t.string :title

      t.timestamps
    end
  end
end
