require 'rails_helper'
	
describe LedgersHelper do

	let(:ledger) { FactoryGirl.create(:cash_ledger) }
    let(:tr_hash) { ParseDefaultCSV.new("#{Rails.root}/files/with_vat_ledgerCSV.csv").return_data }
    
    before do 
    	# uses manual to ensure acc_date in range of default range filter
		book_trn_with_vat_and_tags
		#ledger.book_default_csv(tr_hash)
    end
    let(:data) { @data = LedgersTransactionService.new(ledger, {}).set_show_page }

    context "test env SetUP" do
    	it 'should have transactions with tags' do
		  expect(ledger.transactions.count).to eq 272
		end
		it 'should have data set' do
	      expect(data[:timeline_transactions].count).to eq 272
		end
    end

	context "CASHLEDGER showPage" do
		describe 'cashbook view pivot helper methods' do
			before do
				@data = data
				$trns_for_view = show_first_20
			end
			it 'can get first 20 transactions' do
				expect($trns_for_view.count).to eq 20
			end
			it 'can get monea_tags from $trns' do
				expect(map_monea_tags).to eq ["Sales", "Trade debtors"]
			end
			it 'can set headers and data variables from $trns' do
				set_cash_book_headers
				expect($cashbook_headers).to eq ["Sales", "Trade debtors"]
				expect($cash_book_columns).to eq 2
				expect($css_column_width).to eq 0.03333333333333333
			end	
			it 'can sum a list of trns' do
				set_cash_book_headers
				test_trns = [nil, nil, 3757.3524889, 7733.609438, 1583.7793152]
				expect(sum_list{test_trns}).to eq 13074
			end
		end 
    end

	def book_trn_with_vat_and_tags
		tr_hash.each do |trans|
	      mi_tag = trans['mi_tag'] || "No-Mapping"
	      a = ledger.transactions.build(acc_date: Time.now-3.day, amount: trans["amount"], monea_tag: trans["monea_tag"], mi_tag: mi_tag, vat: trans["vat"] )
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



