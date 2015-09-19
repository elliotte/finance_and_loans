require 'rails_helper'

describe LedgerImportService do

  let(:csv_file) { File.open("#{Rails.root}/files/with_vat_ledgerCSV.csv") }
  let(:ledger) { FactoryGirl.create(:cash_ledger) }
  let(:import_service) { LedgerImportService.new(ledger, csv_file, {"bank" => "false"} ) }

  describe 'initialising' do
      it 'should not initialise without a file or ledger' do
        expect { LedgerImportService.new }.to raise_error(StandardError)
      end

      it 'should initialise successfully with a file and ledger' do
        expect { LedgerImportService.new(ledger, csv_file, {}) }.to_not raise_error
      end
  end

  describe 'service methods' do
      it 'should know if default' do
        expect(import_service.options["bank"]).to eq "false"
      end

      it 'sets data using parse file method' do
        import_service.parse_file
        expect(import_service.data.count).to eq 516
      end

      it 'can get master monea_tags' do
        import_service.set_monea_tags
        expect(import_service.monea_tags.count).to eq 90
      end

      it 'return true valid tag' do
        import_service.set_monea_tags
        monea_tag = "Sales"
        a = import_service.valid(monea_tag)
        expect(a).to eq true
      end

      it 'return false with invalid tag' do
        import_service.set_monea_tags
        monea_tag = "nn"
        a = import_service.valid(monea_tag)
        expect(a).to eq false
      end

      it 'can index data with non-valid monea tags' do
        import_service.parse_file
        import_service.set_monea_tags
        a = import_service.index_null_monea_tags
        expect(a.count).to eq 48
      end
      #how to test set_invalid no mapping?
      it 'should have 82 transactions' do
        expect(import_service.ledger_collection.count).to eq 0
        import_service.book_data
        expect(ledger.transactions.count).to eq 516
      end
      it 'should have two no-mapping transactions' do
        import_service.book_data
        no_mappings_count = ledger.transactions.select{|trn| trn[:monea_tag] == "No-Mapping"}.count
        expect(no_mappings_count).to eq 96
      end

      it 'should return true as all data trans booked' do
        expect(import_service.book_data).to eq true
      end

      it 'should book vat' do
        import_service.book_data
        lst_trn = ledger.transactions.last
        expect(lst_trn.vat.to_f.round(2)).to eq 240.8
      end

      it 'should not book negative vat' do
        #first trn in csv has negative vat
        import_service.book_data
        lst_trn = ledger.transactions.first
        expect(lst_trn.vat.to_f.round(2)).to eq 939.34
      end
      # GO INTO TEST CSV AND CHANGE vat > VAT and run tests to see pass as well
  end

end

