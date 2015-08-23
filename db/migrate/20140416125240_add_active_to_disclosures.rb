class AddActiveToDisclosures < ActiveRecord::Migration
  def change
    add_column :disclosures, :active, :boolean
  end
end
