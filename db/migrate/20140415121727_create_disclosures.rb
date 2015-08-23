class CreateDisclosures < ActiveRecord::Migration
  def change
    create_table :disclosures do |t|
      t.text :body
      t.string :type
      t.references :report, index: true
      t.string :added_by

      t.timestamps
    end
  end
end
