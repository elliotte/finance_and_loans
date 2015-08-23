class AddInvoiceFileLinkToLedgers < ActiveRecord::Migration
  def change
  	add_column :transactions, :invoice_file_link, :string
  end
end
