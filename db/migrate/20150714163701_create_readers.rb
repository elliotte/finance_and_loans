class CreateReaders < ActiveRecord::Migration
  def change
    create_table :readers do |t|
      t.references :report, index: true, foreign_key: true
      t.string :uid

      t.timestamps null: false
    end
  end
end
