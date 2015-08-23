class CreateLedgers < ActiveRecord::Migration
  def change
    create_table :ledgers do |t|
      t.string :type
      t.string :user_tag

      t.timestamps
    end
  end
end
