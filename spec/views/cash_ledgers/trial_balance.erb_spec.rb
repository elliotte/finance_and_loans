require 'rails_helper'

RSpec.describe "cash_ledgers/trial_balance", :type => :view do
  
  let(:ledger) { FactoryGirl.create(:cash_ledger) }
  let(:csv_file) { File.open("#{Rails.root}/spec/fixtures/ledgerCSVTBTest.csv") }
  
  before do 
    book_trans_csv_with_tags
  end

  describe "setup of ledger and testing env" do
    it "has transactions booked before starting" do
      expect(ledger.transactions.count).to eq 490
    end
  end

  describe "basic TB display" do
    it 'should have ledger summary rows(table with hidden GLs) rendered' do
      render
      rendered.should have_css('table.gl-summary-table', :count => 10)
    end
    it 'should have a ledger accounts selectors rendered' do
      render
      rendered.should have_selector('td.ledger_account', text: 'Bank charges')
      rendered.should have_selector('td.ledger_account', text: 'Bank loans')
      rendered.should have_selector('td.ledger_account', text: 'Purchases')
      rendered.should have_selector('td.ledger_account', text: 'Sales')
      rendered.should have_selector('td.ledger_account', text: 'Stock')
      rendered.should have_selector('td.ledger_account', text: 'Trade creditors')
      rendered.should have_selector('td.ledger_account', text: 'No-Mapping')
      rendered.should have_selector('td.ledger_account', text: 'VAT')
      rendered.should have_selector('td.ledger_account', text: 'Trade debtors')
      rendered.should have_selector('td.ledger_account', text: 'Bank account')
    end
    it 'should have correct totals' do
      render
      # BANK ACCOUNT
      rendered.should have_selector('td.debit', text: '33568')
      #STOCK
      rendered.should have_selector('td.debit', text: '137580')
      #BANK CHARGES
      rendered.should have_selector('td.debit', text: '135212')
      #BANK LOANS
      rendered.should have_selector('td.credit', text: '-249609')
      #NO MAPPING
      rendered.should have_selector('td.debit', text: '233729')
      #VAT
      rendered.should have_selector('td.credit', text: '-56015')
      #TRADE DEBTORS
      rendered.should have_selector('td.credit', text: '862907')
    end
    it 'should have hidden tables detailing GL transactions' do
      expect(render).to render_template(:'cash_ledgers/_general_ledger_tables')
    end
    
  end

  def book_trans_csv_with_tags
      LedgerImportService.new(ledger, csv_file, {'bank' => "false"}).book_data
      @ledger = ledger
      @data = TrialBalance.new(ledger).return_general_ledger
  end

end

    # render partial: 'headlines_summary_table'
    # rendered.should have_content("Sum of Lodgements: £3265.72")
    # rendered.should have_content("No of Transactions: 47")
    # rendered.should have_content("Net: £1208.15")