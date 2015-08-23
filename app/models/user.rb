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
      rescue
        true
      end
      #load_templates
  	end

  	def load_welcome_reports
  		file = "#{Rails.root}/files/welcome_rep.csv"
  		values = ParseValuesCSV.new(file).return_data
  		report = self.reports.build(title: 'IFRS example report', summary: "Demo monea.report IFRS reporting .. view various current and comparative summaries of report values, add notes and comments, view your financial statements dashboard and link reconciliations, create statutory accounts, export contents to Google or share with other colleagues or accountants", current_end: Date.new(2014,12,31), comparative_end: Date.new(2013,12,31), format: 'IFRS', report_type: 'Statutory')
  		report.save
  		WelcomeService.new(report).load_ifrs_report(values)
      file = "#{Rails.root}/files/welcome_rep_gaap.csv"
      values = ParseValuesCSV.new(file, "UKGAAP").return_data
      report_gaap = self.reports.build(title: 'UK-GAAP example report', summary: "Demo monea.report reporting .. view various current and comparative summaries of report values, add notes and comments, view your financial statements dashboard and link reconciliations, create statutory accounts, export contents to Google or share with other colleagues or accountants", current_end: Date.new(2014,12,31), comparative_end: Date.new(2013,12,31), format: 'UKGAAP', report_type: 'Statutory')
      report_gaap.save
      WelcomeService.new(report_gaap).load_gaap_report(values)
  	end

  	def load_welcome_ledgers
  		file = "#{Rails.root}/files/welcome_led.csv"
  		trns = ParseDefaultCSV.new(file).return_data
  		ledger = self.ledgers.create(user_tag: "CashLedger no VAT example", type: "CashLedger")
		  WelcomeService.new(ledger).load_ledger(trns)
      file = "#{Rails.root}/files/with_vat_ledgerCSV.csv"
      vat_trns = ParseDefaultCSV.new(file).return_data
      vat_ledger = self.ledgers.create(user_tag: "CashLedger with VAT example", type: "CashLedger")
      WelcomeService.new(vat_ledger).load_ledger(vat_trns)
  	end

end



