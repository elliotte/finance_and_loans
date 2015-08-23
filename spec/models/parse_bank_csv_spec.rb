require 'rails_helper'

describe ParseBankCSV do

    let(:file) { "#{Rails.root}/spec/fixtures/test_bank.csv" }

    let(:new_parser) { ParseBankCSV.new(file) }

  	it 'should not initialise without a file' do
  		expect { ParseBankCSV.new }.to raise_error
  	end

  	it 'should initialise successfully with a file' do
  		expect { ParseBankCSV.new(file) }.not_to raise_error
  	end

    it 'should be able to read a file without headers' do
      expect(new_parser.read_file_with_headers.count).to eq 84
    end

    it 'should be able to read a file with headers' do
      expect(new_parser.read_file_without_headers.count).to eq 85
    end

    it 'should set csv data as class instance' do
      new_parser.set_bank_data_instance
      expect(new_parser.bank_data[3]).to eq({"Date"=>"24/09/2014", " Type"=>"POS", " Description"=>"'0853 23SEP14 , AUTOROUTE DU SUD , VEDENE CEDEX FR , EUR 16.90, VRATE 1.2678, FGN PUR FEE 1.00", " Value"=>"-14.33", " Balance"=>"3103.62", " Account Name"=>"'ELLIOTT ME", " Account Number"=>"'830608-11775465", nil=>nil})
    end

    it 'has returns true if a row has greater than 3 fields' do
      new_parser.set_bank_data_instance
      row = new_parser.bank_data[3]
      this = new_parser.a_real_row?(row)
      expect(this).to eq true
    end

    it 'returns false if a row has less than 3 fields' do
      new_parser.set_bank_data_instance
      row = new_parser.bank_data[0]
      this = new_parser.a_real_row?(row)
      expect(this).to eq false
    end

    it 'returns false for keys in scope' do
      a = new_parser.not_in_scope?("Value")
      expect(a).to eq false
    end

    it 'returns true for keys not in scope' do
      a = new_parser.not_in_scope?("Bell")
      expect(a).to eq true
    end

    it 'can loop @bank_data and extract in_scope' do
      new_parser.set_bank_data_instance
      new_parser.loop_bank_data_and_extract
      expect(new_parser.extracted_data[2][0]).to eq "24/09/2014"
    end

    it 'can cleanse to real rows only' do
      new_parser.set_bank_data_instance
      new_parser.loop_bank_data_and_extract
      expect(new_parser.extracted_data.count).to eq 84
      new_parser.cleanse_extracted_data
      expect(new_parser.extracted_data.count).to eq 82
    end

    it 'can parse_extracted data' do
      new_parser.set_bank_data_instance
      new_parser.loop_bank_data_and_extract
      new_parser.cleanse_extracted_data
      this = new_parser.parse_extracted_data
      expect(this[0][:acc_date]).to eq "24/09/2014"
    end

   it 'can create a bank transaction hash' do
      this = new_parser.return_data
      expect(this.count).to eq 82
   end

  	# it 'should have client as accessible instance' do
  	# 	client.stub(:discovered_api)
  	# 	service = GoogleService.new(client)
  	# 	expect(service.client).to eq client
  	# end

  	# it 'should receive a discovered_api call on intialising and set drive' do
  	# 	allow(client).to receive(:discovered_api).and_return(@drive = "Hello Test")
  	# 	service = GoogleService.new(client)
  	# 	expect(service.drive).to eq "Hello Test"
  	# end

  	# it 'should respond to upload ledger call' do
  	# 	allow(client).to receive(:discovered_api).and_return("OK")
  	# 	service = GoogleService.new(client)
  	# 	expect(service).to respond_to(:upload_ledger_csv)
  	# end

end
