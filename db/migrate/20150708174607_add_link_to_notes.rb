class AddLinkToNotes < ActiveRecord::Migration
   def up
    add_column :notes, :filelink, :string
  end

  def down
    add_column :notes, :filelink, :string
  end
end
