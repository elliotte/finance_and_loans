class SalesLedger < Ledger
  
  after_create :build_back_end

  def build_back_end
      @google_service ||= GoogleService.new($client, $authorization)
      folder_url = @google_service.create_user_invoice_folder(user_tag)
      self.drive_folder = folder_url
      set_invoice
      self.save
  end

  def aged_30_to_90_days
    _start = Date.current - 4.month
    _end = Date.current - 1.month
    transactions.for_date( _start.at_beginning_of_month, _end.at_end_of_month )
  end

  def not_paid
    transactions.invoices.where(paid: false)
  end

  def paid
    transactions.invoices.where(paid: true)
  end

  def contents_to_csv(data)
    CSV.open("#{Rails.root}/files/new-file.csv", 'w') do |csv|
      header = data.last.attribute_names
      csv << header
      data.each do |trn|
        csv << trn.attributes.values_at(*header)
      end
    end
  end
  
private 
 
  def set_invoice
  	if invoice_template_file_link.blank?
      self.invoice_template_file_link = set_default_template
    else
      copy_user_inv_template
    end
  end

  def set_default_template
    # to connect when switch to admin acc done
    drive_folder.match(/id=([\S]+)&/)
    @google_service.copy_file('1acyxVwOmDnGqWOCPSZutFIrhIf0dMR1OwWoQoHaPPAc', 'invoice.template', $1)
  end

  def copy_user_inv_template
    template_file_id  = extract_inv_file_id
    if !template_file_id
      set_default_template
    else
      drive_folder.match(/id=([\S]+)&/)
      new_URL = @google_service.copy_file(template_file_id, 'invoice.template', $1)
      self.invoice_template_file_link = new_URL
    end
  end

  def extract_inv_file_id
    invoice_template_file_link.match(/d\/(.*)?.edit/)[1]
  end

end

