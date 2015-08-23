class RemoveColumn < ActiveRecord::Migration
  def change
  	remove_column :badlines, :user_id
  end
end
