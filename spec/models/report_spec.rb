require 'rails_helper'

describe Report do

  before do 
      Report.any_instance.stub(:build_back_end).and_return(true)
  end
  context "Associations" do
      it { should have_many :values }
      it { should have_many :tb_values }
      it { should have_many :etb_values }
      it { should have_many :disclosures }
      it { should have_many :notes }
      it { should have_many :comments }
      it { should have_many :readers }
      it { should belong_to :user }
      it { should accept_nested_attributes_for(:values) }
      it { should accept_nested_attributes_for(:tb_values) }
      it { should accept_nested_attributes_for(:etb_values) }
      it { should validate_presence_of(:title) }
  end

  let(:report) do
    FactoryGirl.create(:report)
  end
  
  context "Duck typing" do
    it 'should respond to' do
      expect(report).to respond_to :title
      expect(report).to respond_to :summary
      expect(report).to respond_to :format
      expect(report).to respond_to :current_end
      expect(report).to respond_to :comparative_end
      expect(report).to respond_to :drive_folder
    end
  end
  context "after create" do
    it "fires create drive folder" do
      report = Report.new(title: 'REPORT-TEST')
      expect(report).to receive(:build_back_end).and_return(true)
      report.save
    end
  end

  context "do date filter range lookups" do
    let(:report_populated) do
      FactoryGirl.create(:report_with_values_this_month)
    end
    let(:report_populated_next_month) do
      FactoryGirl.create(:report_with_values_next_month)
    end
    it 'should be able to get 5 current month values' do
      expect(report_populated.get_values_for(Time.now).count).to eq 5
    end
    it 'should be able to get 0 last month values' do
      expect(report_populated.get_values_for(Time.now+1.month).count).to eq 0
    end
    it 'should be able to get 0 current month values' do
      expect(report_populated_next_month.get_values_for(Time.now).count).to eq 0
    end
    it 'should be able to get 10 next month values' do
      expect(report_populated_next_month.get_values_for(Time.now+1.month).count).to eq 10
    end
    it 'should be able to accept a TYPE filter' do
      a = EtbValue.new(amount: 10.00, repdate: Time.now+1.month+1.day )
      report_populated_next_month.values << a
      expect(report_populated_next_month.get_values_for(Time.now+1.month, "EtbValue").last).to eq a
    end
    it 'should have 5 values' do
      expect(report_populated.values.count).to eq 5
    end
    it 'should have 5 TB values' do
      expect(report_populated.values.first).to be_a(TbValue)
      expect(report_populated.values.last).to be_a(TbValue)
    end
    it 'should have a ETB values' do
      report_populated.values << FactoryGirl.create(:etb_value)
      expect(report_populated.values.last).to be_a(EtbValue)
    end
  end
  context "booking values" do
    it 'can book a TBVALUES CSV with a hash' do
          csv_file = File.open("#{Rails.root}/spec/fixtures/report_values.csv")
          expect(report.values.count).to eq 0
          v_hash = ParseValuesCSV.new(csv_file).return_data
          report.book_values(v_hash)
          expect(report.values.count).to eq 313
    end
    it 'can book an ETB values as a journal' do
        etb_values = {"1"=>{"repdate(2i)"=>"3", "repdate(1i)"=>"2014", "repdate(3i)"=>"1", "amount"=>"12121", "ifrstag"=>"Other operating income"}, "2"=>{"repdate(2i)"=>"12", "repdate(1i)"=>"2015", "repdate(3i)"=>"1", "amount"=>"66666", "ifrstag"=>"Revenue"}, "3"=>{"repdate(2i)"=>"12", "repdate(1i)"=>"2015", "repdate(3i)"=>"1", "amount"=>"322555", "ifrstag"=>"Administrative expenses"}}
        expect(report.etb_values.count).to eq 0
        report.book_journal(etb_values, "Being description")
        expect(report.etb_values.count).to eq 3
    end
  end
  context "parsing data" do
    before do 
       # ParseValuesCSV.any_instance.stub(:return_data).and_return(true)
    end
    it 'pass two args with GAAP' do
      # report.update(format: "UKGAAP")
      # ParseValuesCSV.should_receive(:new).with("/Users/edwardelliott/Documents/Projects/MoneaReport/spec/fixtures/test_default.csv", "UKGAAP")
      # file = File.open("#{Rails.root}/spec/fixtures/test_default.csv")
      # report.parse_csv_and_book file
    end
    it 'pass one arg with IFRS' do
    end
  end
  context "exporting dash data to Google" do
      it 'should write metaData to CSV' do
        params = {"_json"=>[["Revenue", 9393.38, 18184.23, "gp-rev"], ["Other trading income", 19334.02, 18048.09, "gp-rev"], ["Cost of sales", 17468.89, 9393.38, "gp-cos"], ["Other direct costs", 4292.63, 19334.02, "gp-cos"], ["Changes in inventories of finished goods and work in progress", 1133.15, 13951.97, "gp-cos"], ["Raw materials and consumables used", 12929.32, 5963.15, "gp-cos"], ["Other operating income", 3204.88, 17468.89, "op-rev"], ["Finance income", 13443.81, 4292.63, "op-rev"], ["Share of post-tax profits of equity associates", 2168.56, 3204.88, "op-rev"], ["Share of post-tax profits of equity joint ventures", 12122.64, 13443.81, "op-rev"], ["Administrative expenses", 11896.08, 2168.56, "op-cos"], ["Distribution expenses", 2137.59, 12122.64, "op-cos"], ["Other expenses", 26488.85, 15377.29, "op-cos"], ["Finance expense", 13951.97, 2137.59, "op-cos"], ["Employee benefit expenses", 13970.25, 1133.15, "op-cos"], ["Depreciation and amortisation expense", 3481.21, 12929.32, "op-cos"], ["Research and development", 12338.75, 13970.25, "op-cos"], ["Other expenses", 26488.85, 15377.29, "op-cos"], ["Exchange gains arising on translation of foreign operations", 17241.88, 12467.18, "op-cos"], ["Tax expense", 5963.15, 11535.29, "tax"], ["Property, plant and equipment", 7102.95, 15446.19, "assets"], ["Investment property", 17689.73, 10951.4, "assets"], ["Goodwill", 2553.91, 7102.95, "assets"], ["Other intangible assets", 17095.49, 17689.73, "assets"], ["Finance lease receiveable", 24414.37, 12553.99, "assets"], ["Other financial assets", 11473.35, 17095.49, "assets"], ["Other assets", 15555.52, 22148.22, "assets"], ["Investments in equity-accounted associates", 2985.01, 11473.35, "assets"], ["Investments in equity-accounted joint ventures", 8287.2, 8438.46, "assets"], ["Available-for-sale investments", 35257.29, 19865.1, "assets"], ["Derivative financial assets", 9139.18, 18504.56, "assets"], ["Inventories", 16880.09, 6517.65, "assets"], ["Trade and other receivables", 10217.36, 17241.88, "assets"], ["Available-for-sale investments", 35257.29, 19865.1, "assets"], ["Derivative financial assets", 9139.18, 18504.56, "assets"], ["Current tax assets", 132.59, 16792.57, "assets"], ["Other assets", 15555.52, 22148.22, "assets"], ["Cash and cash equivalents", 10000.08, 132.59, "assets"], ["Assets in disposal groups classified as held for sale", 15446.19, 7117.05, "assets"], ["Finance lease receiveable", 24414.37, 12553.99, "assets"], ["Other receivables", 17774.57, 18464.71, "assets"], ["Deferred tax assets", 16637.33, 453.94, "assets"], ["Loans and borrowings", 12899.47, 5788.66, "liabs"], ["Derivative financial liabilities", 32163.39, 9736.99, "liabs"], ["Employee benefit liabilities", 34948.86, 24578.08, "liabs"], ["Provisions ", 11874.18, 19227.75, "liabs"], ["Deferred tax liability", 11944.94, 17152.89, "liabs"], ["Other financial liabilities", 12713.79, 11874.18, "liabs"], ["Deferred revenue", 9198.49, 11944.94, "liabs"], ["Other liabilities", 10983.53, 12713.79, "liabs"], ["Trade and other payables", 11710.19, 17774.57, "liabs"], ["Loans and borrowings", 12899.47, 5788.66, "liabs"], ["Derivative financial liabilities", 32163.39, 9736.99, "liabs"], ["Income Tax Payable", 12381.18, 1257.03, "liabs"], ["Employee benefit liabilities", 34948.86, 24578.08, "liabs"], ["Provisions", 10848.67, 12381.18, "liabs"], ["Liabilities directly associated with assets in HFS", 1973.2, 17795.97, "liabs"]], "controller"=>"reports", "action"=>"export_dash", "id"=>"49", "report"=>{}}
        report.export_dash_to_csv(params["_json"])
        expected_csv = File.read("#{Rails.root}/files/new-file.csv")
        expect(expected_csv).to eq "Reporting Line,December 2014,December 2013,FS Mapping\nRevenue,9393.38,18184.23,gp-rev\nOther trading income,19334.02,18048.09,gp-rev\nCost of sales,17468.89,9393.38,gp-cos\nOther direct costs,4292.63,19334.02,gp-cos\nChanges in inventories of finished goods and work in progress,1133.15,13951.97,gp-cos\nRaw materials and consumables used,12929.32,5963.15,gp-cos\nOther operating income,3204.88,17468.89,op-rev\nFinance income,13443.81,4292.63,op-rev\nShare of post-tax profits of equity associates,2168.56,3204.88,op-rev\nShare of post-tax profits of equity joint ventures,12122.64,13443.81,op-rev\nAdministrative expenses,11896.08,2168.56,op-cos\nDistribution expenses,2137.59,12122.64,op-cos\nOther expenses,26488.85,15377.29,op-cos\nFinance expense,13951.97,2137.59,op-cos\nEmployee benefit expenses,13970.25,1133.15,op-cos\nDepreciation and amortisation expense,3481.21,12929.32,op-cos\nResearch and development,12338.75,13970.25,op-cos\nOther expenses,26488.85,15377.29,op-cos\nExchange gains arising on translation of foreign operations,17241.88,12467.18,op-cos\nTax expense,5963.15,11535.29,tax\n\"Property, plant and equipment\",7102.95,15446.19,assets\nInvestment property,17689.73,10951.4,assets\nGoodwill,2553.91,7102.95,assets\nOther intangible assets,17095.49,17689.73,assets\nFinance lease receiveable,24414.37,12553.99,assets\nOther financial assets,11473.35,17095.49,assets\nOther assets,15555.52,22148.22,assets\nInvestments in equity-accounted associates,2985.01,11473.35,assets\nInvestments in equity-accounted joint ventures,8287.2,8438.46,assets\nAvailable-for-sale investments,35257.29,19865.1,assets\nDerivative financial assets,9139.18,18504.56,assets\nInventories,16880.09,6517.65,assets\nTrade and other receivables,10217.36,17241.88,assets\nAvailable-for-sale investments,35257.29,19865.1,assets\nDerivative financial assets,9139.18,18504.56,assets\nCurrent tax assets,132.59,16792.57,assets\nOther assets,15555.52,22148.22,assets\nCash and cash equivalents,10000.08,132.59,assets\nAssets in disposal groups classified as held for sale,15446.19,7117.05,assets\nFinance lease receiveable,24414.37,12553.99,assets\nOther receivables,17774.57,18464.71,assets\nDeferred tax assets,16637.33,453.94,assets\nLoans and borrowings,12899.47,5788.66,liabs\nDerivative financial liabilities,32163.39,9736.99,liabs\nEmployee benefit liabilities,34948.86,24578.08,liabs\nProvisions ,11874.18,19227.75,liabs\nDeferred tax liability,11944.94,17152.89,liabs\nOther financial liabilities,12713.79,11874.18,liabs\nDeferred revenue,9198.49,11944.94,liabs\nOther liabilities,10983.53,12713.79,liabs\nTrade and other payables,11710.19,17774.57,liabs\nLoans and borrowings,12899.47,5788.66,liabs\nDerivative financial liabilities,32163.39,9736.99,liabs\nIncome Tax Payable,12381.18,1257.03,liabs\nEmployee benefit liabilities,34948.86,24578.08,liabs\nProvisions,10848.67,12381.18,liabs\nLiabilities directly associated with assets in HFS,1973.2,17795.97,liabs\n"
      end
      it 'should export values to CSV for spreadsheet' do
      rep = FactoryGirl.create(:report_with_values_next_month)
      rep.spreadsheet_export("Values", Time.now, Time.now+1.month)
      expected_csv = File.read("#{Rails.root}/files/new-file.csv")
      test_result = "Values,Exported from monea.build\n37"
      expect(expected_csv.slice(0,35)).to eq test_result
    end
  end
  context "Journals" do
    it 'returns last value mitag' do
      report.values << FactoryGirl.create(:etb_value, number: 98)
      report.values << FactoryGirl.create(:etb_value, number: 99)
      etb_values = {"1"=>{"repdate(2i)"=>"3", "repdate(1i)"=>"2014", "repdate(3i)"=>"1", "amount"=>"12121", "ifrstag"=>"Other operating income"}, "2"=>{"repdate(2i)"=>"12", "repdate(1i)"=>"2015", "repdate(3i)"=>"1", "amount"=>"66666", "ifrstag"=>"Revenue"}, "3"=>{"repdate(2i)"=>"12", "repdate(1i)"=>"2015", "repdate(3i)"=>"1", "amount"=>"322555", "ifrstag"=>"Administrative expenses"}} 
      report.book_journal(etb_values, "TEST JNL")
      expect(report.values.last).to be_a(EtbValue)
      expect(report.values.last.number).to eq 100
    end
    it 'returns a value for journal' do
      report.values << FactoryGirl.create(:etb_value, number: 2)
      expect(report.calculate_jnl_no).to eq(3)
    end
  end

  context "fetching export data based on request" do
    before do
      report.values << FactoryGirl.create(:etb_value)
      FactoryGirl.create(:disclosure, report_id: report.id)
      FactoryGirl.create(:note, report_id: report.id)
      FactoryGirl.create(:comment, report_id: report.id)
    end

    it 'returns values data for value request' do
      expect(report.get_export_data(:values, Time.now, (Time.now+1.month))).to eq({values: [report.get_values_for(Time.now), report.get_values_for(Time.now+1.month)]})
    end

    it 'returns disclosures data for disclosures request' do
      expect(report.get_export_data(:disclosures, '', '')).to eq({disclosures: [report.disclosures]})
    end

    it 'returns notes data for notes request' do
      expect(report.get_export_data(:notes, '', '')).to eq({notes: [report.notes]})
    end

    it 'returns comments data for comments request' do
      expect(report.get_export_data(:comments, '', '')).to eq({comments: [report.comments]})
    end

    it 'returns all data for all request' do
      report_data_hash = {
        values: [report.get_values_for(Time.now), report.get_values_for(Time.now+1.month)],
        notes: [report.notes],
        disclosures: [report.disclosures],
        comments: [report.comments]
      }
      expect(report.get_export_data(:all, Time.now, Time.now+1.month)).to eq(report_data_hash)
    end

  end

  # it 'can get director report type disclosures' do
  #   disclosures = report.get_disclosures_for_dirrep
  #   expect(disclosures.count).to eq 7
  # end

  # it 'can get genearl type disclosures' do
  #   disclosures = report.get_disclosures_for_general
  #   expect(disclosures.count).to eq 6
  # end

  # it 'can get active disclosures' do
  # end

  # it 'can get non-active disclosures' do
  # end


end
