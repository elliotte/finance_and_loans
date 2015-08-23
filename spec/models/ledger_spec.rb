require 'rails_helper'

describe Ledger do

  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:transactions) }
    it { is_expected.to have_many(:viewers) }
    it { is_expected.to validate_presence_of :user_tag}
  end

  describe 'non ledgerClass methods' do
    it { is_expected.not_to respond_to(:create_drive_folder) }
    it { is_expected.not_to respond_to(:copy_user_inv_template) }
    it { is_expected.not_to respond_to(:set_default_template) }
  end

  describe 'model scopes' do
    it 'respond to user last_four scope ' do
      expect(Ledger).to respond_to(:last_four)
    end
  end

  describe 'ledger query and summarise methods' do
    before do
      @ledger = FactoryGirl.create(:ledger)
      FactoryGirl.create(:credit_transaction, mi_tag: 'Cost_1', amount: 10.01, acc_date: Date.today, ledger: @ledger)
      FactoryGirl.create(:credit_transaction, mi_tag: 'Cost_1', amount: 10.01, acc_date: Date.today, ledger: @ledger)
      FactoryGirl.create(:debit_transaction, mi_tag: 'Cost_1', amount: 10.02, acc_date: Date.today, ledger: @ledger)
      FactoryGirl.create(:credit_transaction, mi_tag: 'Cost_2', amount: 10.03, acc_date: Date.today, ledger: @ledger)
    end
    it 'should return 3 credit transactions' do
      credit_transactions = @ledger.credit_transactions
      expect(credit_transactions.count).to eq 3
    end
    it 'should return 1 debit credit transactions' do
      debit_transactions = @ledger.debit_transactions
      expect(debit_transactions.count).to eq 1
    end
    it 'can query current month' do
      expect(@ledger.transactions_current_month.count).to eq 4
    end
    it 'can query last month' do
      expect(@ledger.transactions_prior_month.count).to eq 0
    end
    it 'can query last 3 months ie quarter' do
      expect(@ledger.transactions_last_3_months.count).to eq 4
    end
    it 'should call check_or_set_ob before create' do
      ledger = Ledger.new(user_tag: 'OB_Test')
      expect(ledger).to receive(:check_or_set_ob).and_return(0.00)
      ledger.save
    end
    it 'should set ob if none given' do
      expect(@ledger.opening_balance).to eq 0.00      
    end
  end

 
end
