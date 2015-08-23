class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :commenter
      t.text :body
      t.references :report, index: true
      t.string :type

      t.timestamps
    end
  end
end
