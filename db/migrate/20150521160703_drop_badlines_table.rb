class DropBadlinesTable < ActiveRecord::Migration
  def change
  	drop_table :badlines
  end
end
