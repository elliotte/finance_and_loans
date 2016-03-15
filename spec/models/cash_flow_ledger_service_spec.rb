require 'rails_helper'

describe CashFlowLedgerService do

  before do 
    @ledger = FactoryGirl.create(:cash_flow_ledger)
  end
  describe 'Initialisation' do
    it 'should not initialise without a ledger' do
      expect { CashFlowLedgerService.new }.to raise_error
    end
    it 'should initialise successfully with a ledger' do
      expect { CashFlowLedgerService.new(@ledger) }.not_to raise_error
    end
    it 'should set REV tags' do
      tags = CashFlowLedgerService.new(@ledger).instance_variable_get(:@rev_tags)
      expect(tags).to eq ["Sales", "Other sales"]
    end
    it 'should set COS tags' do
      tags = CashFlowLedgerService.new(@ledger).instance_variable_get(:@cos_tags)
      expect(tags).to eq ["Purchases", "Decrease in stocks", "Subcontractor costs", "Direct labour", "Carriage", "Discounts allowed", "Commissions payable", "Other direct costs"]
    end
  end

  describe 'query CF transactions' do
    
    before do
      Tag.gaap_fin_stat_tags[:gp_cos].each do |tag|
        #two trans per mitag ( each trn different month )
        trn_1, trn_2 = FactoryGirl.create(:credit_transaction, acc_date: Time.now+1.month, monea_tag: tag, mi_tag: "TestMI #{tag}"), FactoryGirl.create(:credit_transaction, acc_date: Time.now+2.month, monea_tag: tag, mi_tag: "TestMI #{tag}")
        @ledger.transactions << trn_1
        @ledger.transactions << trn_2
      end
    end

    let(:cf_service) { CashFlowLedgerService.new(@ledger) }

    it 'should have 16 starting COS trns' do
      expect(@ledger.transactions.count).to eq 16
    end
    it 'can group & manipulate for VIEW display' do
      tags = Tag.gaap_fin_stat_tags[:gp_cos]
      trns = cf_service.group_trns_by_mi(tags.first)
      
      view_result_required = []
      trns.each do |row, index|
        # vars taken from _saved_transactions template
        view_result_required << row.acc_date.month-1
        view_result_required << row.amount.to_i
      end
      expect(view_result_required).to eq [3, 9, 4, 9]
    end

  end
 
end
