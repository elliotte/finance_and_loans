class CreateViewers < ActiveRecord::Migration
  def change
    create_table :viewers do |t|
      t.references :ledger, index: true, foreign_key: true
      t.string :uid

      t.timestamps null: false
    end
  end
end
