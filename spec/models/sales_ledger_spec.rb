require 'rails_helper'

describe SalesLedger do
  before do 
      Transaction.any_instance.stub(:create_drive_file).and_return(true)
      SalesLedger.any_instance.stub(:build_back_end).and_return(true)
  end
  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:transactions) }
    it { is_expected.to have_many(:viewers) }
    it { is_expected.not_to accept_nested_attributes_for(:transactions) }
  end
  describe 'sales ledger ONLY methods' do
    it { is_expected.to respond_to(:build_back_end) }
    it { is_expected.to respond_to(:aged_30_to_90_days) }
    it { is_expected.to respond_to(:not_paid) }
    it { is_expected.to respond_to(:paid) }
  end
  describe 'sales ledger private methods' do
    it { is_expected.not_to respond_to(:create_folder_and_set_invoice) }
    it { is_expected.not_to respond_to(:set_default_template) }
    it { is_expected.not_to respond_to(:copy_user_inv_template) }
    it { is_expected.not_to respond_to(:extract_inv_file_id) }
  end
  context "after create methods" do
    it "fires create drive folder" do
      ledger = SalesLedger.new(user_tag: 'Sales_Test')
      expect(ledger).to receive(:build_back_end).and_return(true)
      ledger.save
    end
  end
  context 'WRITE to CSV' do
    before do 
      @ledger = FactoryGirl.create(:sales_ledger)
      @ledger.transactions.create(type: "Transaction", amount: 10.01, acc_date: Date.yesterday, paid: false)
      CSV.open("#{Rails.root}/files/new-file.csv", 'w') do |csv|
        csv
      end
    end
    it 'should write trn attributes' do
      @ledger.contents_to_csv(@ledger.not_paid)
      expected_csv = File.read("#{Rails.root}/files/new-file.csv")
      expect(expected_csv[0..50]).to eq "ledger_id,id,type,amount,monea_tag,mi_tag,created_a"
    end
  end

  context "filter methods" do
    before do 
      @ledger = FactoryGirl.create(:sales_ledger)
      @ledger.transactions.create(type: "Transaction", amount: 10.01, acc_date: Date.yesterday, paid: false)
    end
    it 'should call for date filter for AGED' do
      collection = @ledger.transactions
      expect(collection).to receive(:for_date)
      @ledger.aged_30_to_90_days
    end
  end

  context "build backend methods" do
    before do 
      @test_folder = "https://drive.google.com/drive/folders/0B_6-7ExYPpj6Qzh5SmJ4X2JHMFU"
      @test_link = "https://docs.google.com/document/d/1keFMeO1qA5EUVJXcuc3ubrrRPZqkgJ4RL29SfikPy8A/edit"
    end

    it 'returns true if template link set' do
      ledger = SalesLedger.new(user_tag: 'Sales_Test', invoice_template_file_link: @test_link)
      expect( ledger.invoice_template_file_link.blank? ).to eq false
    end
     it 'returns false if template link not set' do
      ledger = SalesLedger.new(user_tag: 'Sales_Test')
      expect( ledger.invoice_template_file_link.blank? ).to eq true
    end
    it 'should call default template if no link set' do
      ledger = SalesLedger.new(user_tag: 'Sales_Test')
      expect(ledger).to receive(:set_default_template)
      ledger.send(:set_invoice)
    end
    it 'should call copy template if link set' do
      ledger = SalesLedger.new(user_tag: 'Sales_Test', invoice_template_file_link: @test_link)
      expect(ledger).to receive(:copy_user_inv_template)
      ledger.send(:set_invoice)
    end
    it 'can extract fileID from google link' do
      ledger = SalesLedger.new(user_tag: 'Sales_Test', invoice_template_file_link: @test_link)
      expect( ledger.send(:extract_inv_file_id) ).to eq "1keFMeO1qA5EUVJXcuc3ubrrRPZqkgJ4RL29SfikPy8A"
    end

  end

end
