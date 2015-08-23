class AddFieldsToNotes < ActiveRecord::Migration
  def up
    add_column :notes, :subject, :string
    add_column :notes, :repdate, :date
  end

  def down
    add_column :notes, :subject, :string
    add_column :notes, :repdate, :date
  end
end
