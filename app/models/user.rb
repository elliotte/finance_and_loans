class User < ActiveRecord::Base

	  has_many :reports, dependent: :destroy

	  has_many :ledgers, dependent: :destroy
    has_many :cash_ledgers, dependent: :destroy, class_name: 'CashLedger'
    has_many :sales_ledgers, dependent: :destroy, class_name: 'SalesLedger'
  	
    after_create :load_welcome_packs
    
    scope :last_four, -> {order('updated_at desc').first(4)}

  	def load_welcome_packs
      begin
        load_welcome_ledgers
  		  load_welcome_reports
        load_welcome_sales
      rescue
        true
      end
      #load_templates
  	end

  	def load_welcome_reports
  		file = "#{Rails.root}/files/welcome_rep.csv"
  		values = ParseValuesCSV.new(file).return_data
  		report = self.reports.create(title: 'IFRS example report', 
              summary: "Demo monea.report IFRS reporting .. view various current and comparative summaries of report values, add notes and comments, view your financial statements dashboard and link reconciliations, create statutory accounts, export contents to Google or share with other colleagues or accountants", 
              current_end: Date.new(2014,12,31), 
              comparative_end: Date.new(2013,12,31), 
              format: 'IFRS', 
              report_type: 'Statutory')

      return if report.nil?
  		WelcomeService.new(report).load_ifrs_report(values)
      
      file = "#{Rails.root}/files/welcome_rep_gaap.csv"
      values = ParseValuesCSV.new(file, "UKGAAP").return_data
      report_gaap = self.reports.create(title: 'UK-GAAP example report', 
          summary: "Demo monea.report reporting .. view various current and comparative summaries of report values, add notes and comments, view your financial statements dashboard and link reconciliations, create statutory accounts, export contents to Google or share with other colleagues or accountants", 
          current_end: Date.new(2014,12,31), 
          comparative_end: Date.new(2013,12,31), 
          format: 'UKGAAP', 
          report_type: 'Statutory')

      return if report.nil?
      WelcomeService.new(report_gaap).load_gaap_report(values)
  	end

  	def load_welcome_ledgers
  		# file = "#{Rails.root}/files/welcome_led.csv"
  		# trns = ParseDefaultCSV.new(file).return_data
  		# ledger = self.ledgers.create(user_tag: "No VAT demo simple booking, TBs and exporting", type: "CashLedger" )
		  # WelcomeService.new(ledger).load_ledger(trns)
      file = "#{Rails.root}/files/with_vat_ledgerCSV.csv"
      vat_trns = ParseDefaultCSV.new(file).return_data
      vat_ledger = self.ledgers.create(user_tag: "Demo Cash with VAT, simple booking, TBs and exporting", type: "CashLedger")
      WelcomeService.new(vat_ledger).load_ledger(vat_trns)
  	end

    def load_welcome_sales
      ledger = self.ledgers.create(user_tag: "Demo sales: 3 months folder ", type: "SalesLedger")
      return if ledger.nil?
      ledger.transactions.create(type: "Transaction", acc_date: Time.now, amount: 4560.00, vat: 345.00, description: "First sale in monea.build", paid: false)
      ledger.transactions.create(type: "Transaction", acc_date: Time.now, amount: 14560.00, vat: 3145.00, description: "2nd sale in monea.build", paid: false)
      #fileID = trn_to_be_paid.invoice_file_link.match(/d\/(.*)?.edit/)[1]
      #google_service.rename_inv_file_paid($fileID, session[:token])
    end

end



