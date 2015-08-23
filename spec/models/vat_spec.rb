require 'rails_helper'

describe VAT do

    let(:vat_ledger) { FactoryGirl.create(:cash_ledger) }
    let(:sales_ledger) { FactoryGirl.create(:sales_ledger) }

    before do 
      SalesLedger.any_instance.stub(:build_back_end)
      trns = ParseDefaultCSV.new("#{Rails.root}/files/vatTest.csv").return_data
      # USE BOOKING HELPER TO CONTROL DATES
      book_with_vat(trns)
      $vat_service =  VAT.new(vat_ledger)
    end

    describe "intialising" do
      it 'should not initialise without a ledger' do
        expect{VAT.new()}.to raise_error
      end
      it 'should initialise with a ledger' do
        expect{VAT.new(vat_ledger)}.not_to raise_error
      end
    end

    describe "summary builder" do
      it 'should set csv data' do
         $vat_service =  VAT.new(vat_ledger)
         $vat_service.build_data
         expect($vat_service.summary[:csv_data]).to eq({:payments=>[["Number of transactions", 1], ["Vat", 2000], ["Net", 98000], ["Gross", 100000]], :receipts=>[["Number of transactions", 3], ["Vat", 23], ["Net", 100764], ["Gross", 100787]], :total=>[["No of trns", 4], ["total net purchases", 98000], ["vat_paid", 2000], ["Total net sales", 100764], ["VAT sales", 23], ["Vat amount due", 1977]]})
      end
        it 'should set 0.00 csv data' do
         $vat_service =  VAT.new(vat_ledger, Date.current-2.year,Date.current-1.year )
         $vat_service.build_data
         expect($vat_service.summary[:csv_data]).to eq({:payments=>[["Number of transactions", 0], ["Vat", 0], ["Net", 0], ["Gross", 0]], :receipts=>[["Number of transactions", 0], ["Vat", 0], ["Net", 0], ["Gross", 0]], :total=>[["No of trns", 0], ["total net purchases", 0], ["vat_paid", 0], ["Total net sales", 0], ["VAT sales", 0], ["Vat amount due", 0]]})
      end
      it 'should set a populated summary' do
         $vat_service =  VAT.new(vat_ledger)
         $vat_service.build_data
         $vat_service.set_vat_return
         expect($vat_service.summary[:vat_return]).to eq([["VAT due this period on sales and other outputs", "Box 1", 23], ["VAT due in this period on acquisitions from other EC Member States", "Box 2", 0], ["Total VAT due", "Box 3", 23], ["VAT reclaimed in this period on purchases and other inputs (including acquisitions from EC)", "Box 4", 2000], ["VAT to/from customs", "Box 5", -1977], ["Total value of sales and all other outputs excluding VAT (including supplies to EC)", "Box 6", 100764], ["Total value of purchases and all other inputs excluding VAT (including acquisitions from EC)", "Box 7", 98000], ["Total value of all supplies of goods, excluding any VAT, to other EC Member States", "Box 8", 0], ["Total value of all acquisitions of goods, excluding any VAT, from EC Member States", "Box 9", 0]])
      end
        it 'should set 0.00 populated summary' do
         $vat_service =  VAT.new(vat_ledger, Date.current-2.year,Date.current-1.year )
         $vat_service.build_data
         $vat_service.set_vat_return
         expect($vat_service.summary[:vat_return]).to eq [["VAT due this period on sales and other outputs", "Box 1", 0], ["VAT due in this period on acquisitions from other EC Member States", "Box 2", 0], ["Total VAT due", "Box 3", 0], ["VAT reclaimed in this period on purchases and other inputs (including acquisitions from EC)", "Box 4", 0], ["VAT to/from customs", "Box 5", 0], ["Total value of sales and all other outputs excluding VAT (including supplies to EC)", "Box 6", 0], ["Total value of purchases and all other inputs excluding VAT (including acquisitions from EC)", "Box 7", 0], ["Total value of all supplies of goods, excluding any VAT, to other EC Member States", "Box 8", 0], ["Total value of all acquisitions of goods, excluding any VAT, from EC Member States", "Box 9", 0]]
      end
    end

    describe "helpers" do
      it 'can return true if cash ledger' do
        expect($vat_service.ledger_type_cash?).to eq true
      end
      it 'can return false if sales ledger' do
        expect(VAT.new(sales_ledger).ledger_type_cash?).to eq false
      end
      it 'returns false if no dates set' do
        expect(VAT.new(sales_ledger).date_range_valid?).to eq false
      end
      it 'returns false if one date set' do
        expect(VAT.new(sales_ledger, Date.current).date_range_valid?).to eq false
      end
      it 'returns true if two date set' do
        vat = VAT.new(sales_ledger, Date.current, Date.current-1.day)
        expect(vat.date_range_valid?).to eq true
      end
      it 'sets trns with 4 dates given' do
        $vat_service =  VAT.new(vat_ledger, Date.current-15.day, Date.current)
        $vat_service.set_trns
        expect($vat_service.trns.count).to eq 4
      end
       it 'sets trns with 0 dates given[scope out of range]' do
        $vat_service =  VAT.new(vat_ledger, Date.current-2.year, Date.current-1.year)
        $vat_service.set_trns
        expect($vat_service.trns.count).to eq 0
      end
      it 'sets trns with no end Date' do
        $vat_service =  VAT.new(vat_ledger, Date.current-15.day)
        $vat_service.set_trns
        expect($vat_service.trns.count).to eq 4
      end
      it 'sets trns with no Dates given' do
        $vat_service =  VAT.new(vat_ledger)
        $vat_service.set_trns
        expect($vat_service.trns.count).to eq 4
      end
      it 'can filter to 1 payments' do
        $vat_service =  VAT.new(vat_ledger)
        $vat_service.set_trns
        $vat_service.filter_payments
        expect($vat_service.payments.count).to eq 1
      end
      it 'can filter to 3 receipts' do
        $vat_service =  VAT.new(vat_ledger)
        $vat_service.set_trns
        $vat_service.filter_receipts
        expect($vat_service.receipts.count).to eq 3
      end
    end

    describe "data query methods" do
      it 'can return 4 past quarter transactions' do
        trns = $vat_service.past_quarter_transactions
        expect(trns.count).to eq 4
      end
      it 'sets 4 transactions' do
        trns = $vat_service.query_range
        expect($vat_service.trns.count).to eq 4
      end
      it 'can returns zero when dates send out of range' do
        $vat_service =  VAT.new(vat_ledger, Date.current-2.year, Date.current-1.year)
        $vat_service.query_range
        expect($vat_service.trns.count).to eq 0
      end
      it 'can split into credits' do
        $vat_service.query_range
        expect($vat_service.bank_credits{$trns}.first).to be_a(Credit)
      end
      it 'can split into debits' do
        $vat_service.query_range
        expect($vat_service.bank_debits{$trns}.first).to be_a(Debit)
      end
    end
  # HELPERS
  def book_with_vat trns
      trns.each do |trans|
        mi_tag = trans['Your tag']
        a = vat_ledger.transactions.build(acc_date: Date.current-12.day, amount: trans["Amount"], monea_tag: trans["Monea Tag"], mi_tag: mi_tag, vat: trans["VAT"] )
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
