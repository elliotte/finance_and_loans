class AddColumnToReport < ActiveRecord::Migration
  def change
    add_reference :reports, :user, index: true
  end
end
