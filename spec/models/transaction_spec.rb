require 'rails_helper'

describe Transaction do
 
  describe "types" do
    it "can initialize successfully as a Transaction" do
      expect{Transaction.new(amount: 10, acc_date: Date.yesterday)}.not_to raise_error
      expect(Transaction.new(amount: 10, acc_date: Date.yesterday).type).to eq nil
    end
    it "can initialize successfully as a Credit" do
      expect{Credit.new(amount: 10, acc_date: Date.yesterday)}.not_to raise_error
      expect(Credit.new(amount: 10, acc_date: Date.yesterday).type).to eq "Credit"
    end
    it "can initialize successfully as a Debit" do
      expect{Debit.new(amount: 10, acc_date: Date.yesterday)}.not_to raise_error
      expect(Debit.new(amount: 10, acc_date: Date.yesterday).type).to eq "Debit"
    end
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:ledger) }
  end

  describe "duck typing" do
    it { is_expected.to respond_to(:amount) }
    it { is_expected.to respond_to(:monea_tag) }
    it { is_expected.to respond_to(:mi_tag) }
    it { is_expected.to respond_to(:type) }
    it { is_expected.to respond_to(:acc_date) }
    it { is_expected.to respond_to(:vat) }
    it { is_expected.to respond_to(:paid) }
  end

  describe "defaults" do
    it "Transaction has paid true and vat 0.00" do
      Transaction.any_instance.stub(:create_drive_file).and_return(true)
      transaction = FactoryGirl.create(:transaction, amount: 10.01, acc_date: Date.yesterday)
      expect(transaction.paid).to eq true
      transaction = FactoryGirl.create(:transaction, amount: 1, acc_date: Date.yesterday)
      expect(transaction.vat).to eq 0.00
    end

    it "credit has paid true and vat 0.00" do
      transaction = FactoryGirl.create(:credit_transaction, amount: 10.01, acc_date: Date.yesterday)
      expect(transaction.paid).to eq true
      transaction = FactoryGirl.create(:credit_transaction, amount: 1, acc_date: Date.yesterday)
      expect(transaction.vat).to eq 0.00
    end
    it 'debit has paid true and vat 0.00' do
      transaction = FactoryGirl.create(:debit_transaction, amount: 10.04, acc_date: Date.yesterday)
      expect(transaction.paid).to eq true
      transaction = FactoryGirl.create(:debit_transaction, amount: 1, acc_date: Date.yesterday)
      expect(transaction.vat).to eq 0.00
    end
  end

  describe 'Scopes' do
    it 'should returns all credit transactions' do
      transaction = FactoryGirl.create(:credit_transaction, amount: 10, acc_date: Date.yesterday, ledger: @ledger)
      expect(Transaction.credit).to eq([transaction])
    end

    it 'should returns all debit transactions' do
      transaction = FactoryGirl.create(:debit_transaction, amount: 10, acc_date: Date.yesterday, ledger: @ledger)
      expect(Transaction.debit).to eq([transaction])
    end

    it 'search for dates' do
      transaction = FactoryGirl.create(:debit_transaction, amount: 10, acc_date: Date.yesterday, ledger: @ledger)
      expect(Transaction.for_date(Date.yesterday, Date.today)).to eq([transaction])
    end
  end
end

describe "financial control when saved" do
  it 'should not allow a negative entry as a booking' do
    transaction = Transaction.new(amount: -10.00, acc_date: Date.yesterday)
    expect(transaction.amount).to eq -10
    transaction.save
    expect(transaction.amount).to eq 10.00
  end
  it 'should not have a blank mi_tag' do
    transaction = Transaction.create(amount: 10, acc_date: Date.yesterday)
    transaction.mi_tag.should_not be_blank
  end 
  it 'should default mi_tag to No-miTag' do
     transaction = Transaction.create(amount: 10, acc_date: Date.yesterday)
     transaction.mi_tag.should == "No-miTag"
  end 
  it 'should default mi_tag to No-miTag with empty string passed' do
     transaction = Transaction.create(amount: 10, acc_date: Date.yesterday, mi_tag: "")
     transaction.mi_tag.should == "No-miTag"
  end 
  it 'should not have a blank monea_tag' do
    transaction = Transaction.create(amount: 10, acc_date: Date.yesterday)
    transaction.mi_tag.should_not be_blank
  end 
  it 'should default monea tag' do
     transaction = Transaction.create(amount: 10, acc_date: Date.yesterday)
     transaction.monea_tag.should == "No-Mapping"
  end 

  describe "VAT" do
    it 'should have a vat attribute' do
      transaction = FactoryGirl.create(:credit_transaction)
      expect(transaction).to respond_to(:vat)
    end
    it 'should have a vat attribute as 0.00 default if not given' do
      transaction = FactoryGirl.create(:credit_transaction)
      expect(transaction.vat).to eq 0.00
    end
    it 'should not allow a negative amount to be saved' do
      transaction = Credit.new(acc_date: Time.now, amount: 1000, vat: -10.00)
      transaction.save
      expect(transaction.vat).to eq 10
    end
  end
  
end


