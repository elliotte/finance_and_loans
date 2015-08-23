class AddDescToValueTable < ActiveRecord::Migration
  def change
    add_column :values, :description, :string
  end
end
