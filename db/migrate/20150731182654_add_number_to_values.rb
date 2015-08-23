class AddNumberToValues < ActiveRecord::Migration
  def change
    add_column :values, :number, :integer
  end
end
