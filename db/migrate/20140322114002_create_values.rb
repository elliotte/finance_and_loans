class CreateValues < ActiveRecord::Migration
  def change
    create_table :values do |t|
      t.references :report, index: true
      t.datetime :repdate
      t.string :badline

      t.timestamps
    end
  end
end
