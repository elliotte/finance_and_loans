class AddColumnIfrsToValues < ActiveRecord::Migration
  def change
    add_column :values, :ifrstag, :string
  end
end
