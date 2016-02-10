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
        expect(@ledger.base_assumptions).to eq ( {:format=>{:start_month=>"January", :cf_length=>"Full-Year"}, :select_options=>{:start_month=>["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"], :cf_length=>["Quarter", "Half-Year", "Full-Year"]}}) 
     end
     it 'loads cf drivers data' do
        expect(@ledger.cf_drivers_data).to eq ( {:loans=>{:rate=>0.01, :term=>6, :amt=>0.0}, :vat=>{:cost_rate=>0.2, :sales_rate=>0.2}, :non_director_wages=>{:ppl=>0, :total_cost=>0}, :director_wages=>[], :employer_nics=>{:rate=>0.138}} ) 
     end
  end

end
