require 'rails_helper'

describe LedgersTransactionService do

    let(:ledger) { FactoryGirl.create(:cash_ledger) }
    let(:params_tm) { {"period"=>"this_month", "action"=>"transactions_for", "controller"=>"ledgers", "id"=>"7"} }
    let(:params_lm) { {"period"=>"last_month", "action"=>"transactions_for", "controller"=>"ledgers", "id"=>"7"} }
    let(:params_mn) { {"period"=>"manual", "from"=>{"date(1i)"=>"2013", "date(2i)"=>"8", "date(3i)"=>"24"}, "to"=>{"date(1i)"=>"2014", "date(2i)"=>"11", "date(3i)"=>"24"}, "button"=>"", "action"=>"transactions_for", "controller"=>"ledgers", "id"=>"7"} }
    let(:transaction_service) { LedgersTransactionService.new(ledger, params_tm) }

  	it 'should not initialise without a client' do
  		expect { LedgersTransactionService.new }.to raise_error(StandardError)
  	end

  	it 'should initialise successfully with a client' do
  		expect { transaction_service }.not_to raise_error
  	end

    it 'should return true if this month period' do
      expect(transaction_service.period_this_month?).to eq true
    end

    it 'should know false if not month period' do
      ts = LedgersTransactionService.new(ledger, params_lm)
      expect(ts.period_this_month?).to eq false
    end

    it 'should know true if prior period' do
      ts = LedgersTransactionService.new(ledger, params_lm)
      expect(ts.period_prior_month?).to eq true
    end

    it 'should know true if prior period' do
      ts = LedgersTransactionService.new(ledger, params_tm)
      expect(ts.period_prior_month?).to eq false
    end

    it 'should know true if manual' do
      ts = LedgersTransactionService.new(ledger, params_mn)
      expect(ts.period_manual?).to eq true
    end

    it 'should know false if not manual' do
      ts = LedgersTransactionService.new(ledger, params_tm)
      expect(ts.period_manual?).to eq false
    end

    it 'should respond to load data' do
      expect(transaction_service).to respond_to(:load_data)
    end

    it 'should respond to calc headlines' do
      expect(transaction_service).to respond_to(:calc_headlines)
    end

    it 'should respond to set show page' do
      expect(transaction_service).to respond_to(:set_show_page)
    end

    it 'should respond to filtered transactions' do
      expect(transaction_service).to respond_to(:filtered_transactions)
    end

    it 'should respond to get date' do
      expect(transaction_service).to respond_to(:date_from_params)
    end

    it 'can get current month transactions' do
       test_trans = FactoryGirl.create(:transaction)
       ledger.transactions << test_trans
       expect(transaction_service.all_cm_trans[0].mi_tag).to eq 'MyString'
    end

    it 'can get prior month transactions' do
       test_trans = FactoryGirl.create(:transaction, acc_date: DateTime.now - 1.month)
       ledger.transactions << test_trans
       expect(transaction_service.all_pm_trans[0].mi_tag).to eq "MyString"
    end

    it 'can separate transactions into debits and credits' do
      test_credit = FactoryGirl.create(:credit_transaction)
      test_debit = FactoryGirl.create(:debit_transaction)
      ledger.transactions << test_credit
      ledger.transactions << test_debit
      expect(transaction_service.all_cm_trans.debit).to eq [test_debit]
      expect(transaction_service.all_cm_trans.credit).to eq [test_credit]
    end

    it 'should set its data instance hash for current month' do
       ledger.transactions << FactoryGirl.create(:credit_transaction)
       ledger.transactions << FactoryGirl.create(:debit_transaction)
       transaction_service.set_current_month_transactions
       expect(transaction_service.data[:timeline_transactions].count).to eq 2
       expect(transaction_service.data[:lodgements].count).to eq 1
       expect(transaction_service.data[:payments].count).to eq 1
    end

    it 'should set its data instance hash for prior month' do
       ledger.transactions << FactoryGirl.create(:credit_transaction, acc_date: DateTime.now - 1.month)
       ledger.transactions << FactoryGirl.create(:debit_transaction, acc_date: DateTime.now - 1.month)
       transaction_service.set_prior_month_transactions
       expect(transaction_service.data[:timeline_transactions].count).to eq 2
       expect(transaction_service.data[:lodgements].count).to eq 1
       expect(transaction_service.data[:payments].count).to eq 1
    end

    it 'should set its data instance hash for last 3 months' do
       ledger.transactions << FactoryGirl.create(:credit_transaction, acc_date: Time.now-40.days)
       ledger.transactions << FactoryGirl.create(:debit_transaction, acc_date: Time.now-40.days)
       ledger.transactions << FactoryGirl.create(:credit_transaction)
       ledger.transactions << FactoryGirl.create(:debit_transaction)
       transaction_service.set_qtr_transactions
       expect(transaction_service.data[:timeline_transactions].count).to eq 4
    end
    #add non stubbed too
    it 'should set its data instance hash for manual month' do
       ts = LedgersTransactionService.new(ledger, params_mn)
       ledger.stub(:summarise).and_return(["Only testing setting of variable"])
       ts.stub(:calc_headlines).and_return(ts.data[:headlines] = "only testing")
       ts.set_manual_transactions
       expect(ts.data[:lodgements]).to eq(["Only testing setting of variable"])
       expect(ts.data[:payments]).to eq(["Only testing setting of variable"])
       expect(ts.data[:headlines]).to eq 'only testing'
    end

    it 'should respond to headlines' do
      ts = LedgersTransactionService.new(ledger, params_mn)
      ts.set_show_page
      expect(ts.data[:headlines]).to respond_to(:count)
    end

    it 'should have a headline count of 2' do
      ledger.transactions << FactoryGirl.create(:credit_transaction, acc_date: Time.now-40.days)
      ledger.transactions << FactoryGirl.create(:debit_transaction, acc_date: Time.now-40.days)
      ts = LedgersTransactionService.new(ledger, params_mn)
      ts.set_show_page
      expect(ts.data[:headlines][:count]).to eq 2
    end

    it 'can sum lodgements' do
      ledger.transactions << FactoryGirl.create(:debit_transaction, acc_date: Time.now-40.days)
      ledger.transactions << FactoryGirl.create(:debit_transaction, acc_date: Time.now-40.days)
      ts = LedgersTransactionService.new(ledger, params_mn)
      ts.set_qtr_transactions
      expect(ts.sum_lodgements).to eq 19.98
    end

    it 'can sum payments' do
      ledger.transactions << FactoryGirl.create(:credit_transaction, acc_date: Time.now-40.days)
      ledger.transactions << FactoryGirl.create(:credit_transaction, acc_date: Time.now-40.days)
      ts = LedgersTransactionService.new(ledger, params_mn)
      ts.set_qtr_transactions
      expect(ts.sum_payments).to eq 19.98
    end

    it 'can calculate the movement' do
      ledger.transactions << FactoryGirl.create(:credit_transaction, acc_date: Time.now-40.days)
      ledger.transactions << FactoryGirl.create(:credit_transaction, acc_date: Time.now-40.days)
      ledger.transactions << FactoryGirl.create(:debit_transaction, acc_date: Time.now-40.days)
      ts = LedgersTransactionService.new(ledger, params_mn)
      ts.set_qtr_transactions
      expect(ts.calc_mvmt).to eq -9.99
    end

    it 'can calculate all the headlines together' do
      ledger.transactions << FactoryGirl.create(:credit_transaction, acc_date: Time.now-40.days)
      ledger.transactions << FactoryGirl.create(:credit_transaction, acc_date: Time.now-40.days)
      ledger.transactions << FactoryGirl.create(:debit_transaction, acc_date: Time.now-40.days)
      ts = LedgersTransactionService.new(ledger, params_mn)
      ts.set_qtr_transactions
      expect(ts.data[:headlines][:count]).to eq 3
      expect(ts.data[:headlines][:sum_payments]).to eq 19.98
      expect(ts.data[:headlines][:sum_lodgements]).to eq 9.99
      expect(ts.data[:headlines][:mvmt]).to eq -9.99
    end
    
  	# it 'should receive a discovered_api call on intialising and set drive' do
  	# 	allow(client).to receive(:discovered_api).and_return(@drive = "Hello Test")
  	# 	service = GoogleService.new(client)
  	# 	expect(service.drive).to eq "Hello Test"
  	# end

  	# it 'should respond to upload ledger call' do
  	# 	allow(client).to receive(:discovered_api).and_return("OK")
  	# 	service = GoogleService.new(client)
  	# 	expect(service).to respond_to(:upload_ledger_csv)
  	# end

end
