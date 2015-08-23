require 'rails_helper'

describe GoogleService do

	let(:client) { double :client }
  let(:authorisation) { double :authorisation }
  let(:google_ser) { GoogleService.new(client, authorisation)}

  	it 'should not initialise without a client' do
  		expect { GoogleService.new }.to raise_error(StandardError)
  	end

  	it 'should initialise successfully with a client and authorisation' do
      client.stub(:discovered_api)
  		expect { GoogleService.new(client, authorisation) }.not_to raise_error
  	end

  	it 'should have client as accessible instance' do
  		client.stub(:discovered_api)
  		expect(google_ser.client).to eq client
  	end

    it 'should have files as accessible instance and nil on setup' do
      client.stub(:discovered_api)
      expect(google_ser.files).to eq nil
    end

  	it 'should receive a discovered_api call on intialising and set drive' do
  		allow(client).to receive(:discovered_api).and_return(@drive = "Hello Test")
  		expect(google_ser.drive).to eq "Hello Test"
  	end

    it 'should respond to set_auth call' do
      allow(client).to receive(:discovered_api).and_return("OK")
      expect(google_ser).to respond_to(:set_auth)
    end

    it 'should respond to connect_user call' do
      allow(client).to receive(:discovered_api).and_return("OK")
      expect(google_ser).to respond_to(:disconnect_user)
    end

    it 'should respond to get user files' do
      allow(client).to receive(:discovered_api).and_return("OK")
      expect(google_ser).to respond_to(:get_user_files)
    end

    it 'should respond to upload ledger csv call' do
      allow(client).to receive(:discovered_api).and_return("OK")
      expect(google_ser).to respond_to(:upload_ledger_csv)
    end

    it 'should respond to upload ledger tb csv' do
      allow(client).to receive(:discovered_api).and_return("OK")
      expect(google_ser).to respond_to(:upload_new_file_csv)
    end

    it 'should respond to create new spreadsheet' do
      allow(client).to receive(:discovered_api).and_return("OK")
      expect(google_ser).to respond_to(:create_new_spreadsheet)
    end

    it 'should respond to create new document' do
      allow(client).to receive(:discovered_api).and_return("OK")
      expect(google_ser).to respond_to(:create_new_document)
    end

end
