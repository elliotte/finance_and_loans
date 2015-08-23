class AddRepDateInReport < ActiveRecord::Migration
  def self.up
    add_column :reports, :rep_date, :date
  end

  def self.down
    remove_column :reports, :rep_date
  end
end
