class AddColumnsToBadline < ActiveRecord::Migration
  def change
    add_column :badlines, :ifrstag, :string
  end
end
