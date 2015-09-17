class Transaction < ActiveRecord::Base
  
  belongs_to :ledger
  
  validates_presence_of :acc_date
  validates_presence_of :amount
  #using save, not create.. as FC on trnUpdate of VAT required..
  before_save :financial_control

  after_create :create_drive_file

  scope :credit, ->() {where("LOWER(type) = LOWER(?)", 'Credit') }
  scope :debit, ->() {where("LOWER(type) = LOWER(?)", 'Debit') }
  scope :invoices, ->() {where("LOWER(type) = LOWER(?)", 'Transaction' ) }
  
  scope :for_date, ->(start_date, end_date){
    where('DATE(acc_date) >= DATE(?) and DATE(acc_date) <= DATE(?)', start_date, end_date)
  }

  def financial_control
      #transactions are stored as accounting debits and credits which only have positive absolute values
      $already_positive = -> ( amt ) { amt.to_f > 0.00 }
        if vat.nil?
          self.vat = 0.00
        else
          self.vat *= -1 unless $already_positive.call(vat)
        end
        # FOR CASH DEBITS AND CREDITS ONLY
        flip_amt unless $already_positive.call(amount)
        #why is default buggy?
        if vat.nil?
          self.vat = 0.00
        else
          self.vat *= -1 unless $already_positive.call(vat)
        end
        return if type == "Transaction"
        # FOR CASH TRNS ONLY
        set_miTag if needs_financial_control { mi_tag }
        set_moneaTag if needs_financial_control { monea_tag }
  end

  def create_drive_file
    # catch to filter out cashledger transactions ( stored debit and credit )
    return unless type == "Transaction"
    if invoice_file_link.blank?
      @google_service ||= GoogleService.new($client, $authorization)
      ledger.drive_folder.match(/id=([\S]+)&/)
      folder_id = $1
      template_file = ledger.invoice_template_file_link
      template_file.match(/document\/d\/((.)+)\/edit/)
      file_id = $1
      mi_tag.blank? ? _tag = "No-tag given" : _tag = mi_tag
      name = _tag + "( #{self.amount.to_i} )"
      newInvID = @google_service.copy_file(file_id, name, folder_id, "INV")
      self.invoice_file_link = newInvID
      self.save
    end

  end

private 
  
  def flip_amt
    self.amount *= -1
  end

  def needs_financial_control &block
    yield.nil? || yield.length == 0
  end

  def set_miTag
    self.mi_tag = Tag.default_mitag
  end

  def set_moneaTag
    self.monea_tag = Tag.default_monea_tag
  end
  
end
