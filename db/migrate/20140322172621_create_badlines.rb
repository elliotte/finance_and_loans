class CreateBadlines < ActiveRecord::Migration
  def change
    create_table :badlines do |t|
      t.string :title

      t.timestamps
    end
  end
end
