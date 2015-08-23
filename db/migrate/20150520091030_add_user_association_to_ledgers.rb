class AddUserAssociationToLedgers < ActiveRecord::Migration
  def change
  	  add_column :ledgers, :user_id, :integer
      add_index 'ledgers', ['user_id'], :name => 'index_user_id' 
  end
end
