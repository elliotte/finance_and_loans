class AddTitleToDisclosures < ActiveRecord::Migration
  def change
    add_column :disclosures, :title, :string
  end
end
