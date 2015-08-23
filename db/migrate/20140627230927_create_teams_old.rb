class CreateTeamsOld < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :title

      t.timestamps
    end
  end
end
