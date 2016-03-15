require 'rails_helper'

describe CashFlowLedger do

  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:transactions) }
    it { is_expected.to have_many(:viewers) }
  end

  before do 
    @ledger = FactoryGirl.create(:cash_flow_ledger)
  end

  describe 'class methods' do
    it 'should be a cash Ledger' do
      expect(@ledger).to be_a(CashFlowLedger)
    end
     it 'load base assumptions for a cashflow' do
        expect(@ledger.base_assumptions).to eq ( {:format=>{:start_month=>"January", :cf_length=>"Full-Year"}} ) 
     end
     it 'loads cf drivers data' do
        expect(@ledger.cf_drivers_data).to eq ( {:loans=>{:rate=>0.01, :term=>6, :amt=>0.0}, :vat=>{:cost_rate=>0.2, :sales_rate=>0.2}, :non_director_wages=>{:ppl=>0, :total_cost=>0}, :director_wages=>{:ppl=>0, :total_cost=>0}, :employer_nics=>{:rate=>0.138}, :stock=>{:opening_purchase=>0, :closing_leftover=>0}, :customers=>{:opening_owed=>0, :closing_owed=>0}, :fixed_assets=>{:computers=>0, :equipment=>0, :fixtures=>0}} ) 
     end
  end
  # describe 'adding transactions no VAT' do
  #   trn_params = {"vat"=>"false", "transactions"=>{"0"=>{"monea_tag"=>"Sales", "type"=>"Debit", "mi_tag"=>"FirstLine", "Jan 2016"=>"100", "Feb 2016"=>"100", "Mar 2016"=>"100", "Apr 2016"=>"", "May 2016"=>"", "Jun 2016"=>"", "Jul 2016"=>"", "Aug 2016"=>"", "Sep 2016"=>"", "Oct 2016"=>"", "Nov 2016"=>"", "Dec 2016"=>""}, "1"=>{"monea_tag"=>"Sales", "type"=>"Debit", "mi_tag"=>"SecondLine", "Jan 2016"=>"", "Feb 2016"=>"", "Mar 2016"=>"", "Apr 2016"=>"", "May 2016"=>"", "Jun 2016"=>"", "Jul 2016"=>"", "Aug 2016"=>"", "Sep 2016"=>"", "Oct 2016"=>"200", "Nov 2016"=>"200", "Dec 2016"=>"200"}, "2"=>{"monea_tag"=>"Sales", "type"=>"Debit", "mi_tag"=>"", "Jan 2016"=>"", "Feb 2016"=>"", "Mar 2016"=>"", "Apr 2016"=>"", "May 2016"=>"", "Jun 2016"=>"", "Jul 2016"=>"", "Aug 2016"=>"", "Sep 2016"=>"", "Oct 2016"=>"", "Nov 2016"=>"", "Dec 2016"=>""}, "3"=>{"monea_tag"=>"Sales", "type"=>"Debit", "mi_tag"=>"", "Jan 2016"=>"", "Feb 2016"=>"", "Mar 2016"=>"", "Apr 2016"=>"", "May 2016"=>"", "Jun 2016"=>"", "Jul 2016"=>"", "Aug 2016"=>"", "Sep 2016"=>"", "Oct 2016"=>"", "Nov 2016"=>"", "Dec 2016"=>""}, "4"=>{"monea_tag"=>"Other sales", "type"=>"Debit", "mi_tag"=>"", "Jan 2016"=>"", "Feb 2016"=>"", "Mar 2016"=>"", "Apr 2016"=>"", "May 2016"=>"", "Jun 2016"=>"", "Jul 2016"=>"", "Aug 2016"=>"", "Sep 2016"=>"", "Oct 2016"=>"", "Nov 2016"=>"", "Dec 2016"=>""}}}
  #   it 'should be a cash Ledger' do
  #     @ledger.add_user_inputs(trn_params)
  #     expect(@ledger.transactions.count).to eq 6
  #   end
  # end

end
