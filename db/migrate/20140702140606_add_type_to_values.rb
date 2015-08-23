class AddTypeToValues < ActiveRecord::Migration
  def change
    change_column :values, :type, :string, default: 'TbValue'
    Value.update_all(type: 'TbValue')
  end
end
