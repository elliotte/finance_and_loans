class AddFieldsToComments < ActiveRecord::Migration
  def up
    add_column :comments, :subject, :string
    add_column :comments, :repdate, :date
  end

  def down
    add_column :comments, :subject
    add_column :comments, :repdate
  end
end
