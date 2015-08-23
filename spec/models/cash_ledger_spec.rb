require 'rails_helper'

describe CashLedger do

  describe 'Associations' do

    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:transactions) }
    it { is_expected.to have_many(:viewers) }
    it { is_expected.to accept_nested_attributes_for(:transactions) }

  end

  describe 'ledger query and summarise methods' do

    before do
      @ledger = FactoryGirl.create(:cash_ledger)
      FactoryGirl.create(:credit_transaction, mi_tag: 'Cost_1', amount: 10.01, acc_date: Date.today, ledger: @ledger)
      FactoryGirl.create(:credit_transaction, mi_tag: 'Cost_1', amount: 10.01, acc_date: Date.today, ledger: @ledger)
      FactoryGirl.create(:debit_transaction, mi_tag: 'Receipt_1', amount: 10.02, acc_date: Date.today, ledger: @ledger)
      FactoryGirl.create(:debit_transaction, mi_tag: 'Receipt_3', amount: 10.02, acc_date: Date.today, ledger: @ledger)
      FactoryGirl.create(:debit_transaction, mi_tag: 'Receipt_3', amount: 150.75, acc_date: Date.today, ledger: @ledger)
      FactoryGirl.create(:credit_transaction, mi_tag: 'Cost_2', amount: 10.03, acc_date: Date.today, ledger: @ledger)
      FactoryGirl.create(:credit_transaction, mi_tag: 'Cost_3', amount: 33.03, acc_date: Date.today, ledger: @ledger)
    end

    it 'should be a cash Ledger' do
      expect(@ledger).to be_a(CashLedger)
    end

    it 'should return payments' do
      transactions = @ledger.payments
      expect(transactions.count).to eq 4
    end

    it 'should return lodgements' do
      transactions = @ledger.lodgements
      expect(transactions.count).to eq 3
    end

    it 'should group payments by miTag' do
      summarised = @ledger.summarise_payments
      expect(summarised).to eq({"Cost_3"=>33.03, "Cost_2"=>10.03, "Cost_1"=>20.02})
    end

    it 'should group ledgements by miTag' do
      summarised = @ledger.summarise_lodgements
      expect(summarised).to eq({"Receipt_3"=>160.77, "Receipt_1"=>10.02})
    end

    it 'can summarise filtered transactions current month' do
      filtered = @ledger.transactions_current_month 
      summarised = @ledger.summarise(filtered)
      expect(summarised).to eq({"Cost_2"=>10.03, "Receipt_1"=>10.02, "Cost_3"=>33.03, "Receipt_3"=>160.77, "Cost_1"=>20.02})
    end

    it 'can summarise filtered transactions current month' do
      filtered = @ledger.transactions_prior_month 
      summarised = @ledger.summarise(filtered)
      expect(summarised).to eq({})
    end
    
  end

  describe 'importing user CSV' do
    
    before do
      @ledger = FactoryGirl.create(:cash_ledger)
    end
   
    it 'can book a default csv' do
        csv_file = File.open("#{Rails.root}/spec/fixtures/test_default.csv")
        transactions = ParseDefaultCSV.new(csv_file).return_data
        expect(@ledger.transactions.count).to eq 0
        @ledger.book_default_csv(transactions)
        expect(@ledger.transactions.count).to eq 24
    end

    it 'can book a bank CSV' do
        csv_file = File.open("#{Rails.root}/spec/fixtures/test_bank.csv")
        transactions = ParseBankCSV.new(csv_file).return_data
        expect(@ledger.transactions.count).to eq 0
        @ledger.book_bank_csv(transactions)
        expect(@ledger.transactions.count).to eq 82
    end

    it 'knows if bank params are true and processes as a bank csv' do
        options = {bank: "true"}
        csv_file = File.open("#{Rails.root}/spec/fixtures/test_bank.csv")
        transactions = ParseBankCSV.new(csv_file).return_data
        expect(@ledger.transactions.count).to eq 0
        @ledger.parse_csv_and_book(csv_file, options)
        expect(@ledger.transactions.count).to eq 82
    end

    it 'knows if bank params are false and processes as default csv' do
        options = {bank: "false"}
        csv_file = File.open("#{Rails.root}/spec/fixtures/test_default.csv")
        transactions = ParseDefaultCSV.new(csv_file).return_data
        expect(@ledger.transactions.count).to eq 0
        @ledger.book_default_csv(transactions)
        expect(@ledger.transactions.count).to eq 24
    end
  end

  describe 'export transactions to csv' do
    before do 
      @ledger = FactoryGirl.create(:cash_ledger)
      FactoryGirl.create(:credit_transaction, mi_tag: 'Cost_1', amount: 10.01, acc_date: Date.today, ledger: @ledger)
      FactoryGirl.create(:debit_transaction, mi_tag: 'Receipt_3', amount: 150.75, acc_date: Date.today, ledger: @ledger)
      CSV.open("#{Rails.root}/files/new-file.csv", 'w') do |csv|
        csv
      end
    end
    it 'should write data to a csv file' do
      @ledger.export_to_csv(Date.new, Date.new)
      expected_csv = File.read("#{Rails.root}/files/new-file.csv")
      expect(expected_csv).to eq "Booking Date,Amount,VAT,Description,Your tag,Monea Tag\n"
    end
  end

  describe 'export TB to csv' do
      before do 
          @ledger = FactoryGirl.create(:cash_ledger)
          CSV.open("#{Rails.root}/files/new-file.csv", 'w') do |csv|
              csv
          end
      end
      it 'should write tb_METADATA to csv' do
        meta_tb_data = [{"reportingLine"=>"Bank account", "lineAmount"=>-1005000}, {"reportingLine"=>"VAT", "lineAmount"=>126500}, {"reportingLine"=>"Creditor Payment", "lineAmount"=>3500}, {"reportingLine"=>"Debtor Receipt", "lineAmount"=>-95000}, {"reportingLine"=>"Repairs to property", "lineAmount"=>490000}, {"reportingLine"=>"Motor expenses", "lineAmount"=>480000}]
        @ledger.export_tb_to_csv(meta_tb_data)
        expected_csv = File.read("#{Rails.root}/files/new-file.csv")
        expect(expected_csv).to eq "Reporting Line,-,Debit,Credit\nBank account,-,0,-1005000\nVAT,-,126500,0\nCreditor Payment,-,3500,0\nDebtor Receipt,-,0,-95000\nRepairs to property,-,490000,0\nMotor expenses,-,480000,0\n"
      end
  end

  describe 'export GL to csv' do
      before do 
          @ledger = FactoryGirl.create(:cash_ledger)
          CSV.open("#{Rails.root}/files/new-file.csv", 'w') do |csv|
              csv
          end
      end
      it 'should write gl_METADAT to csv' do
        meta_gl_data = [{"glName"=>"Bank account", "trnID"=>2, "amt"=>"-5000.0", "tag"=>"", "date"=>"2015-05-12"}, {"glName"=>"Bank account", "trnID"=>5, "amt"=>"100000.0", "tag"=>"", "date"=>"2015-05-12"}, {"glName"=>"Bank account", "trnID"=>8, "amt"=>"-500000.0", "tag"=>"", "date"=>"2015-05-14"}, {"glName"=>"Bank account", "trnID"=>11, "amt"=>"-600000.0", "tag"=>"", "date"=>"2015-05-11"}, {"glName"=>"VAT", "trnID"=>0, "amt"=>"1500.0", "tag"=>"", "date"=>"2015-05-12"}, {"glName"=>"VAT", "trnID"=>3, "amt"=>"-5000.0", "tag"=>"", "date"=>"2015-05-12"}, {"glName"=>"VAT", "trnID"=>6, "amt"=>"10000.0", "tag"=>"", "date"=>"2015-05-14"}, {"glName"=>"VAT", "trnID"=>9, "amt"=>"120000.0", "tag"=>"", "date"=>"2015-05-11"}, {"glName"=>"Creditor Payment", "trnID"=>1, "amt"=>"3500.0", "tag"=>"", "date"=>"2015-05-12"}, {"glName"=>"Debtor Receipt", "trnID"=>4, "amt"=>"-95000.0", "tag"=>"", "date"=>"2015-05-12"}, {"glName"=>"Repairs to property", "trnID"=>7, "amt"=>"490000.0", "tag"=>"", "date"=>"2015-05-14"}, {"glName"=>"Motor expenses", "trnID"=>10, "amt"=>"480000.0", "tag"=>"", "date"=>"2015-05-11"}]
        @ledger.export_gl_to_csv(meta_gl_data)
        expected_csv = File.read("#{Rails.root}/files/new-file.csv")
        expect(expected_csv).to eq "GL Parent,-,Date,Trn ID,Debit,Credit,yourTag,Description\nBank account,-,2015-05-12,2,0,-5000.0,\"\",\nBank account,-,2015-05-12,5,100000.0,0,\"\",\nBank account,-,2015-05-14,8,0,-500000.0,\"\",\nBank account,-,2015-05-11,11,0,-600000.0,\"\",\nVAT,-,2015-05-12,0,1500.0,0,\"\",\nVAT,-,2015-05-12,3,0,-5000.0,\"\",\nVAT,-,2015-05-14,6,10000.0,0,\"\",\nVAT,-,2015-05-11,9,120000.0,0,\"\",\nCreditor Payment,-,2015-05-12,1,3500.0,0,\"\",\nDebtor Receipt,-,2015-05-12,4,0,-95000.0,\"\",\nRepairs to property,-,2015-05-14,7,490000.0,0,\"\",\nMotor expenses,-,2015-05-11,10,480000.0,0,\"\",\n"
      end
  end

  describe 'adding single transactions to cash ledger' do
      
      before do 
        @ledger = FactoryGirl.create(:cash_ledger)
      end

      it 'books valid transaction' do
        params = {id: @ledger.id, "transaction"=>{"mi_tag"=>"asd", "amount"=>"111", "monea_tag"=>"Debtor Receipt", "acc_date"=>"2015-04-08", "type"=>"Credit"}}
        expect(@ledger.transactions.count).to eq 0
        @ledger.book_single_trn(params['transaction'])
        expect(@ledger.transactions.count).to eq 1
      end

      it 'returns true when booked successfully' do
        params = {id: @ledger.id, "transaction"=>{"mi_tag"=>"asd", "amount"=>"111", "monea_tag"=>"Debtor Receipt", "acc_date"=>"2015-04-08", "type"=>"Credit"}}
        expect(@ledger.transactions.count).to eq 0
        expect(@ledger.book_single_trn(params['transaction'])).to eq true
      end

      it 'does not books in-valid transaction' do
        params = {id: @ledger.id, "transaction"=>{"mi_tag"=>"asd", "amount"=>"111", "monea_tag"=>"Debtor Receipt", "acc_date"=>"", "type"=>"Credit"}}
        expect(@ledger.transactions.count).to eq 0
        @ledger.book_single_trn(params['transaction'])
        expect(@ledger.transactions.count).to eq 0
      end

      it 'returns false when not booked' do
        params = {id: @ledger.id, "transaction"=>{"mi_tag"=>"asd", "amount"=>"", "monea_tag"=>"Debtor Receipt", "acc_date"=>"2015-04-08", "type"=>"Credit"}}
        expect(@ledger.transactions.count).to eq 0
        expect(@ledger.book_single_trn(params['transaction'])).to eq false
      end
  end

end
