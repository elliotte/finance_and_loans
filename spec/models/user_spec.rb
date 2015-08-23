require 'rails_helper'

describe User do

  describe 'Associations' do
  	it { should have_many(:reports) }
  	it { should have_many(:ledgers) }
  	it { should have_many(:cash_ledgers) }
  	it { should have_many(:sales_ledgers) }
  end

  describe 'User after create' do
  	it 'should receive a load welcome docs call' do
	  	user = FactoryGirl.build(:user)
	  	user.should_receive(:load_welcome_packs)
	  	user.save
	end
	it 'should receive a load welcome docs call' do
	  	user = FactoryGirl.build(:user)
	  	user.should_receive(:load_welcome_reports)
	  	user.save
	end
	it 'should receive a load welcome docs call' do
	  	user = FactoryGirl.build(:user)
	  	user.should_receive(:load_welcome_ledgers)
	  	user.save
	end
	it 'should have 2 report after being created' do
		user = FactoryGirl.create(:user)
		expect(user.reports.count).to eq 2
	end
	it 'should have Welcome report title' do
		user = FactoryGirl.create(:user)
		expect(user.reports.first.title).to eq "IFRS example report"
	end
	it 'should have a report with values' do
		user = FactoryGirl.create(:user)
		expect(user.reports.first.values.count).to eq 266
	end
	it 'should have 2 ledgers after being created' do
		user = FactoryGirl.create(:user)
		expect(user.ledgers.count).to eq 2
	end
	it 'should have a ledger with transactions' do
		user = FactoryGirl.create(:user)
		expect(user.ledgers.first.transactions.credit.count).to eq 101
		expect(user.ledgers.first.transactions.debit.count).to eq 153
	end
	it 'should have a ledger transaction with monea_tag' do
		user = FactoryGirl.create(:user)
		expect(user.ledgers.first.transactions.first.monea_tag).to eq "Sales"
	end
  end

  describe 'duck typing specs' do
    it { should respond_to :load_welcome_packs }
    it { should respond_to :load_welcome_reports }
    it { should respond_to :load_welcome_ledgers }
  end

end

