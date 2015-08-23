require 'rails_helper'

describe TrialBalance do

    let(:ledger) { FactoryGirl.create(:cash_ledger) }
    let(:vat_ledger) { FactoryGirl.create(:cash_ledger) }
    
    describe "manipulating features" do
        
        let(:tb) { TrialBalance.new(ledger) }
        
        before do 
           trns = ParseDefaultCSV.new("#{Rails.root}/files/welcome_led.csv").return_data
           book_with_no_vat(trns)
        end

        it 'should pass sufficient data' do
          tb.return_general_ledger
          expect(tb.data["Bank account"][1]).to eq({:id=>3, :date=>"2015-05-01", :amount=>9667.011797, :description=>"Receipt from customer 2", :mi_tag=>"CUST_002"})
        end

    end


    describe "withOut VAT" do
        
        let(:tb) { TrialBalance.new(ledger) }

        before do 
           trns = ParseDefaultCSV.new("#{Rails.root}/files/welcome_led.csv").return_data
           book_with_no_vat(trns)
        end
        it 'should initialise with cash ledger' do
          expect(tb.ledger.type).to eq "CashLedger"
        end
        it 'can get all transactions' do
          tb.fetch_all_trns
          expect(tb.transactions.count).to eq 254
        end
        it 'can set all transactions' do
          tb.fetch_all_trns
          tb.set_t_account_names
          expect(tb.data).to eq({"Bank account"=>[], "VAT"=>[], "Sales"=>[], "Trade debtors"=>[], "Bank loans"=>[], "Trade creditors"=>[], "Purchases"=>[], "Computer equipmt Addi"=>[], "Stock"=>[], "Motor vehicles HP/FL additions "=>[], "Bank charges"=>[]})
        end
        it 'generates double entry bookings' do
          tb.return_general_ledger
          expect(tb.data["Trade debtors"].count).to eq 86
          expect(tb.data["Sales"].count).to eq 18
          expect(tb.data["Bank loans"].count).to eq 39
          expect(tb.data["Purchases"].count).to eq 13 
          expect(tb.data["Bank account"].count).to eq 254
        end
    
    end

    describe "with VAT" do
        
        let(:vat_tb) {TrialBalance.new(vat_ledger) }
        
        before do 
          trns = ParseDefaultCSV.new("#{Rails.root}/files/vatTest.csv").return_data
          book_with_vat(trns)
        end
        it 'has four transactions' do
          expect(vat_ledger.transactions.count).to eq 4
        end
        it 'ledger should have 4 vat transactions' do
          expect(vat_ledger.transactions.first.vat.to_f.round(2)).to eq 2000.00
          expect(vat_ledger.transactions.count).to eq 4
        end
        it 'generates 4 bank transactions' do
          expect(vat_ledger.transactions.count).to eq 4
          data = vat_tb.return_general_ledger
          expect(data["Bank account"].count).to eq 4
        end
        it 'creates the right amount of entries and vat entries' do
           data = vat_tb.return_general_ledger
           expect(data["Bank account"].count).to eq 4
           expect(data["Insurance"].count).to eq 3
           expect(data["Stock"].count).to eq 1
           expect(data["VAT"].count).to eq 3
        end

    end

  # HELPERS
  def book_with_no_vat trns
       trns.each do |trans|
          mi_tag = trans['mi_tag']
          a = ledger.transactions.build(acc_date: trans["accounting date"], amount: trans["amount"], monea_tag: trans["monea_tag"], mi_tag: mi_tag, description: trans["description"] )
            if a.amount < 0.00
              a[:type] = 'Credit'
              a[:amount] = a.amount * -1
            else
               a[:type] = 'Debit'
            end
          a.save
       end
  end
  
  def book_with_vat trns
      trns.each do |trans|
        mi_tag = trans['Your tag']
        a = vat_ledger.transactions.build(acc_date: trans["Booking Date"], amount: trans["Amount"], monea_tag: trans["Monea Tag"], mi_tag: mi_tag, vat: trans["VAT"] )
          if a.amount < 0.00
            a[:type] = 'Credit'
            a[:amount] = a.amount * -1
          else
             a[:type] = 'Debit'
          end
        a.save
      end
  end


end
