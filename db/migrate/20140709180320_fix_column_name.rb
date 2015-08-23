class FixColumnName < ActiveRecord::Migration
  
  def self.up
    rename_column :values, :badline, :mitag
  end

  def self.down
    rename_column :values, :badline, :mitag
  end

end
