require 'rails_helper'

describe ParseValuesCSV do

   let(:file) { "#{Rails.root}/spec/fixtures/report_values.csv" }

    let(:new_parser) { ParseValuesCSV.new(file) }
    let(:new_with_rep_type) { ParseValuesCSV.new(file, "UKGAAP") }

  	it 'should not initialise without a file' do
  		expect { ParseValuesCSV.new }.to raise_error
  	end

    it 'initialises with no report format ' do
      expect(new_parser.format).to eq nil
    end

    it 'initialises with UKGAAP format' do
      expect(new_with_rep_type.format).to eq "UKGAAP"
    end

  	it 'should initialise successfully with a client' do
  		expect { ParseValuesCSV.new(file) }.not_to raise_error
  	end

    it 'should be able to read a file with headers' do
      expect(new_parser.read_file.count).to eq 314
    end

    it 'should set csv data as class instance and use headers' do
      new_parser.fetch_file_values
      expect(new_parser.data[3]).to eq({"reporting month"=>"31/12/2013", "TB code"=>"4", "amount"=>"2146.316367", "description"=>"Sales stream 4", "mi_tag"=>"REGION_001", "ifrstag"=>"Revenue"})
      expect(new_parser.data[0]).to eq (( {"reporting month"=>"31/12/2013", "TB code"=>"1", "amount"=>"4696.690611", "description"=>"Sales stream 1", "mi_tag"=>"REGION_001", "ifrstag"=>"Revenue"}))
      expect(new_parser.data.count).to eq 314
    end
    it 'can read set ifrs tags for lookup' do
      new_parser.set_ifrstags
      expect(new_parser.tags).to eq ["Revenue", "Other trading income", "Cost of sales", "Other direct costs", "Other operating income", "Finance income", "Share of post-tax profits of equity associates", "Share of post-tax profits of equity joint ventures", "Administrative expenses", "Distribution expenses", "Other expenses", "Finance expense", "Tax expense", "Changes in inventories of finished goods and work in progress", "Raw materials and consumables used", "Employee benefit expenses", "Depreciation and amortisation expense", "Research and development", "Other expenses", "Loss on property revaluation", "Remeasurements of defined benefit pension schemes", "Share of associates' other", "Exchange gains arising on translation of foreign operations", "Inventories", "Trade and other receivables", "Available-for-sale investments", "Derivative financial assets", "Current tax assets", "Other assets", "Cash and cash equivalents", "Assets in disposal groups classified as held for sale", "Finance lease receiveable", "Property plant and equipment", "Investment property", "Goodwill", "Other intangible assets", "Finance lease receiveable", "Other financial assets", "Other assets", "Investments in equity-accounted associates", "Investments in equity-accounted joint ventures", "Available-for-sale investments", "Derivative financial assets", "Other receivables", "Deferred tax assets", "Trade and other payables", "Loans and borrowings", "Derivative financial liabilities", "Income Tax Payable", "Employee benefit liabilities", "Provisions", "Liabilities directly associated with assets in HFS", "Loans and borrowings", "Derivative financial liabilities", "Employee benefit liabilities", "Provisions ", "Deferred tax liability", "Other financial liabilities", "Deferred revenue", "Other liabilities", "Revaluation reserve", "Available-for-sale reserve", "Cash flow hedging reserve", "Foreign exchange reserve", "Issued capital and share premium", "Other reserves", "Retained earnings", "Equity attributable to parent", "Non-controlling interest", "Share capital", "Share premium reserve", "Shares to be issued", "No-Mapping"]
    end

    it 'can loop @data and extract in_scope' do
      new_parser.fetch_file_values
      new_parser.loop_and_build_booking_hash
      expect(new_parser.booking[2]).to eq( {:repdate=>"31/12/2013", :amount=>"8734.446753", :mitag=>"REGION_001", :description=>"Sales stream 3", :ifrstag=>"No-Mapping"})
    end

    it 'returns a values hash' do
      expect(new_parser.return_data[1][:amount]).to eq("9667.011797")
    end

    it 'has return 20 No-Mapping booking data hashes' do

      new_parser.return_data
      no_map = []

      new_parser.booking.each do |value|
        if value[:ifrstag] == "No-Mapping"
            no_map << value
        end
      end
      expect(no_map.count).to eq 30

    end


end
