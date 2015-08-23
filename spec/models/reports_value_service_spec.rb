require 'rails_helper'

describe ReportsValueService do

    before { Report.any_instance.stub(:build_back_end) } 
    let(:report) { FactoryGirl.create(:report) }

    let(:vs_empty) { ReportsValueService.new(report) }
    #let(:csv_file) { Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/report_values.csv") }
    let(:file) { "#{Rails.root}/spec/fixtures/current_and_prior.csv" }
    let(:better_file) { "#{Rails.root}/files/welcome_rep_gaap.csv" }
    
    context "initialise" do
      it 'should not initialise without a report' do
        expect { ReportsValueService.new }.to raise_error
      end
      it 'should initialise successfully with a report' do
        expect { ReportsValueService.new(report) }.not_to raise_error
      end
    end
    context "service response basics" do
        it 'should respond to data' do
          expect(vs_empty.data).to eq({})
        end
        it 'knows the reports format' do
          expect(vs_empty.report_format).to eq 'IFRS'
        end
        it 'returns true if report type is statutory' do
          expect(vs_empty.is_stat?).to eq true
        end
        it 'knows the report type' do
          expect(vs_empty.type).to eq 'Statutory'
        end
        it 'knows the report current end' do
          expect(vs_empty.current_end).to be_a Date
        end
        it 'knows the report comparative end' do
          expect(vs_empty.comparative_end).to be_a Date
        end
    end
    context "STAT fetching values and setting data" do
      before do
        #testFile 12/14 and 12/13 data::report current and comparative same
        report.parse_csv_and_book(File.open(file))
      end
      let(:vs_populated) { ReportsValueService.new(report) }

      it 'can retrieve correctly current year end values' do
        expect(vs_populated.get_cye_values.count).to eq 156
      end
      it 'can retrieve correctly comparative end values' do
        expect(vs_populated.get_pye_values.count).to eq 156
      end
      it 'can set data' do
        vs_populated.set_stat_values
        expect(vs_populated.data[:c_period_values].count).to eq 156
        expect(vs_populated.data[:p_period_values].count).to eq 156
      end
      it 'can summarise by mitag and sum amount' do
        values = vs_populated.get_cye_values
        summarised = vs_populated.summarise_by_mitag { values }
        result = {}
        summarised.each do |t|
          result["#{t.mitag}"] = t.sum.to_f
        end
        expect(result).to eq({"REGION_002"=>-56068.6162588, "Trading liability"=>3090827.03869, "Trading asset"=>10978049.8366, "Financing and loans"=>3662618.14108, "REGION_001"=>-14656.957042, "Non Trading asset"=>6980037.4974, "Company equity"=>4520731.93268, "REGION_003"=>24835.9689537})
      end
      it 'can set show summary pivot data' do
        vs_populated.set_stat_values
        result = vs_populated.set_show_summary_pivot
        expect(vs_populated.data[:mitag_summary][:cp]).to eq({"REGION_002"=>-56068.62, "Trading liability"=>3090827.04, "Trading asset"=>10978049.84, "Financing and loans"=>3662618.14, "REGION_001"=>-14656.96, "Non Trading asset"=>6980037.5, "Company equity"=>4520731.93, "REGION_003"=>24835.97})
        expect(vs_populated.data[:description][:cp]).to eq({"Stock asset for sale 7"=>391235.58, "VAT to be paid 1"=>95608.67, "Production cost 14"=>-5491.77, "Bank loan 3"=>50767.24, "Production cost 22"=>-6968.41, "Production cost 9"=>-8576.44, "Bank loan 6"=>355692.24, "Production cost 7"=>-5821.22, "Production cost 11"=>-5972.47, "Production cost 23"=>-2672.69, "Sales stream 23"=>14476.03, "Production cost 12"=>-6356.89, "Sales stream 15"=>12201.34, "Bank account 3"=>428683.07, "Sales stream 21"=>15120.87, "Production cost 24"=>-765.98, "Production cost 32"=>-7908.24, "Bank account 1"=>988112.37, "Fixed assets and investments"=>6980037.5, "Sales stream 9"=>11423.74, "Production cost 5"=>-5424.33, "Production cost 4"=>-8897.99, "Sales stream 8"=>13784.42, "Bank loan 7"=>189003.51, "Production cost 17"=>-642.73, "Wages to be paid 3"=>402818.57, "NICs to be paid 3"=>363586.3, "Stock asset for sale 2"=>824511.18, "Wages to be paid 1"=>305126.48, "Production cost 16"=>-8071.3, "Production cost 19"=>-6270.61, "Production cost 36"=>-9204.46, "Petty Cash 1"=>1922594.35, "Production cost 25"=>-9092.12, "Stock asset for sale 6"=>353604.95, "Sales stream 13"=>11529.32, "Production cost 21"=>-1979.72, "Sales stream 14"=>7298.06, "Bank loan 5"=>668388.79, "Stock asset for sale 10"=>468967.05, "Sales stream 18"=>10312.98, "Production cost 8"=>-9613.87, "Production cost 15"=>-5192.32, "Production cost 31"=>-6389.89, "Sales stream 16"=>11204.36, "Production cost 6"=>-986.6, "Production cost 13"=>-4599.24, "Sales stream 2"=>14775.69, "Production cost 3"=>-6190.59, "Production cost 29"=>-1396.55, "VAT to be paid 2"=>172860.42, "Sales stream 6"=>10280.43, "Production cost 34"=>-8059.61, "Production cost 30"=>-8476.39, "Production cost 10"=>-5937.09, "Production cost 20"=>-8415.71, "Bank account 4"=>955874.48, "Sales stream 7"=>6084.32, "Production cost 28"=>-2357.58, "Production cost 35"=>-6754.95, "Stock asset for sale 5"=>185458.35, "Previous profits 1"=>2346550.45, "Production cost 2"=>-6467.82, "Sales stream 12"=>8252.94, "Stock asset for sale 9"=>852795.24, "Sales stream 20"=>9104.14, "Sales stream 3"=>17130.73, "Bank account 2"=>882746.14, "Sales stream 4"=>6488.94, "NICs to be paid 1"=>777172.24, "Sales stream 10"=>4620.27, "Sales stream 11"=>14612.51, "Stock asset for sale 4"=>559614.24, "VAT to be paid 3"=>204575.88, "Bank loan 8"=>482451.08, "Sales stream 1"=>13136.74, "Stock asset for sale 3"=>585863.23, "Sales stream 5"=>1668.74, "Production cost 1"=>-628.52, "Sales stream 19"=>16709.13, "Production cost 33"=>-6058.48, "Production cost 27"=>-5873.25, "Bank loan 4"=>354512.54, "Bank loan 2"=>774123.75, "Stock asset for sale 8"=>864441.03, "Production cost 26"=>-9024.04, "Bank loan 1"=>787678.99, "NICs to be paid 2"=>464769.29, "Sales stream 17"=>3233.11, "Overhead Cost tracking"=>-82763.22, "Stock asset for sale 1"=>713548.59, "Sales stream 22"=>11577.49, "Production cost 18"=>-5612.8, "Company shares 1"=>2174181.49, "Wages to be paid 2"=>304309.18})
      end
      it 'can load show page VIEW data structure' do
        vs_populated.load_show_page
        expect(vs_populated.data[:mitag_summary][:pp]).to eq({"REGION_002"=>-56068.62, "Trading liability"=>3090827.04, "Trading asset"=>10978049.84, "Financing and loans"=>3662618.14, "REGION_001"=>-14656.96, "Non Trading asset"=>6980037.5, "Company equity"=>4520731.93, "REGION_003"=>24835.97})
        expect(vs_populated.data[:description][:pp]).to eq({"Stock asset for sale 7"=>391235.58, "VAT to be paid 1"=>95608.67, "Production cost 14"=>-5491.77, "Bank loan 3"=>50767.24, "Production cost 22"=>-6968.41, "Production cost 9"=>-8576.44, "Bank loan 6"=>355692.24, "Production cost 7"=>-5821.22, "Production cost 11"=>-5972.47, "Production cost 23"=>-2672.69, "Sales stream 23"=>14476.03, "Production cost 12"=>-6356.89, "Sales stream 15"=>12201.34, "Bank account 3"=>428683.07, "Sales stream 21"=>15120.87, "Production cost 24"=>-765.98, "Production cost 32"=>-7908.24, "Bank account 1"=>988112.37, "Fixed assets and investments"=>6980037.5, "Sales stream 9"=>11423.74, "Production cost 5"=>-5424.33, "Production cost 4"=>-8897.99, "Sales stream 8"=>13784.42, "Bank loan 7"=>189003.51, "Production cost 17"=>-642.73, "Wages to be paid 3"=>402818.57, "NICs to be paid 3"=>363586.3, "Stock asset for sale 2"=>824511.18, "Wages to be paid 1"=>305126.48, "Production cost 16"=>-8071.3, "Production cost 19"=>-6270.61, "Production cost 36"=>-9204.46, "Petty Cash 1"=>1922594.35, "Production cost 25"=>-9092.12, "Stock asset for sale 6"=>353604.95, "Sales stream 13"=>11529.32, "Production cost 21"=>-1979.72, "Sales stream 14"=>7298.06, "Bank loan 5"=>668388.79, "Stock asset for sale 10"=>468967.05, "Sales stream 18"=>10312.98, "Production cost 8"=>-9613.87, "Production cost 15"=>-5192.32, "Production cost 31"=>-6389.89, "Sales stream 16"=>11204.36, "Production cost 6"=>-986.6, "Production cost 13"=>-4599.24, "Sales stream 2"=>14775.69, "Production cost 3"=>-6190.59, "Production cost 29"=>-1396.55, "VAT to be paid 2"=>172860.42, "Sales stream 6"=>10280.43, "Production cost 34"=>-8059.61, "Production cost 30"=>-8476.39, "Production cost 10"=>-5937.09, "Production cost 20"=>-8415.71, "Bank account 4"=>955874.48, "Sales stream 7"=>6084.32, "Production cost 28"=>-2357.58, "Production cost 35"=>-6754.95, "Stock asset for sale 5"=>185458.35, "Previous profits 1"=>2346550.45, "Production cost 2"=>-6467.82, "Sales stream 12"=>8252.94, "Stock asset for sale 9"=>852795.24, "Sales stream 20"=>9104.14, "Sales stream 3"=>17130.73, "Bank account 2"=>882746.14, "Sales stream 4"=>6488.94, "NICs to be paid 1"=>777172.24, "Sales stream 10"=>4620.27, "Sales stream 11"=>14612.51, "Stock asset for sale 4"=>559614.24, "VAT to be paid 3"=>204575.88, "Bank loan 8"=>482451.08, "Sales stream 1"=>13136.74, "Stock asset for sale 3"=>585863.23, "Sales stream 5"=>1668.74, "Production cost 1"=>-628.52, "Sales stream 19"=>16709.13, "Production cost 33"=>-6058.48, "Production cost 27"=>-5873.25, "Bank loan 4"=>354512.54, "Bank loan 2"=>774123.75, "Stock asset for sale 8"=>864441.03, "Production cost 26"=>-9024.04, "Bank loan 1"=>787678.99, "NICs to be paid 2"=>464769.29, "Sales stream 17"=>3233.11, "Overhead Cost tracking"=>-82763.22, "Stock asset for sale 1"=>713548.59, "Sales stream 22"=>11577.49, "Production cost 18"=>-5612.8, "Company shares 1"=>2174181.49, "Wages to be paid 2"=>304309.18})
      end

    end

    context "pivot control welcomeGAAP" do
      before do
        report.parse_csv_and_book(File.open(better_file))
      end
      let(:vs_populated) { ReportsValueService.new(report) }

      it 'can retrieve correctly current year end values' do
        expect(vs_populated.get_cye_values.count).to eq 132
      end
      it 'can retrieve correctly comparative end values' do
        expect(vs_populated.get_pye_values.count).to eq 132
      end
      it 'can set data' do
        vs_populated.set_stat_values
        expect(vs_populated.data[:c_period_values].count).to eq 132
        expect(vs_populated.data[:p_period_values].count).to eq 132
      end
      it 'can summarise by mitag and sum amount' do
        values = vs_populated.get_cye_values
        summarised = vs_populated.summarise_by_mitag { values }
        result = {}
        summarised.each do |t|
          result["#{t.mitag}"] = t.sum.to_f
        end
        expect(result).to eq({"Savings account"=>17007.971553, "Casual labour"=>7225.1342608, "Professional Fees"=>189.18773585, "Rent"=>11721.56085, "Output VAT"=>6570.015831, "PnL CY"=>16097.593982, "Sales stream 5"=>18944.93594, "Client disbursements"=>11769.227235, "CT liability"=>14198.703469, "Cleaning"=>7048.553913, "Premises expenses"=>9496.571334, "Fixtures and Fittings - depn charge"=>3178.41654629, "Directors loan"=>10335.3602557, "Input VAT"=>864.29836259, "Electricty"=>7236.2600098, "Fixtures and Fittings - cost"=>12148.37921, "Sales stream 6"=>14396.876362, "Debtors Control Account"=>3893.0114682, "Recruitment expenses"=>16836.737607, "Training costs"=>22873.603575, "Sales stream 7"=>9455.416347, "Prepayments"=>15878.951103, "Current account"=>2189.7475524, "Audit and accounting fees"=>11834.878892, "Fixtures and Fittings - additions"=>15146.3380142, "Share capital"=>11993.354117, "Accruals & other creditors"=>7016.0189032, "Fixtures and Fittings - acc depn"=>18369.215613, "Dividend Paid"=>3752.9764966, "Petty Cash"=>11805.98937636, "VAT Control"=>15024.736538, "Advertising"=>9410.851151, "Refreshments"=>7722.3718289, "Insurance"=>11790.985484, "Sales stream 9"=>16658.905411, "Sales stream 10"=>8061.3745037, "Sales stream 11"=>17373.46603, "Sales stream 8"=>22242.10665, "Directors salaries"=>162.32356431, "Travel"=>5406.8924091, "Creditors Control Account"=>1537.7852659, "Misc Motor expenses"=>38762.297001})
      end
      it 'can set show summary pivot data' do
        vs_populated.set_stat_values
        result = vs_populated.set_show_summary_pivot
        expect(vs_populated.data[:mitag_summary][:cp]).to eq({"Savings account"=>17007.97, "Casual labour"=>7225.13, "Professional Fees"=>189.19, "Rent"=>11721.56, "Output VAT"=>6570.02, "PnL CY"=>16097.59, "Sales stream 5"=>18944.94, "Client disbursements"=>11769.23, "CT liability"=>14198.7, "Cleaning"=>7048.55, "Premises expenses"=>9496.57, "Fixtures and Fittings - depn charge"=>3178.42, "Directors loan"=>10335.36, "Input VAT"=>864.3, "Electricty"=>7236.26, "Fixtures and Fittings - cost"=>12148.38, "Sales stream 6"=>14396.88, "Debtors Control Account"=>3893.01, "Recruitment expenses"=>16836.74, "Training costs"=>22873.6, "Sales stream 7"=>9455.42, "Prepayments"=>15878.95, "Current account"=>2189.75, "Audit and accounting fees"=>11834.88, "Fixtures and Fittings - additions"=>15146.34, "Share capital"=>11993.35, "Accruals & other creditors"=>7016.02, "Fixtures and Fittings - acc depn"=>18369.22, "Dividend Paid"=>3752.98, "Petty Cash"=>11805.99, "VAT Control"=>15024.74, "Advertising"=>9410.85, "Refreshments"=>7722.37, "Insurance"=>11790.99, "Sales stream 9"=>16658.91, "Sales stream 10"=>8061.37, "Sales stream 11"=>17373.47, "Sales stream 8"=>22242.11, "Directors salaries"=>162.32, "Travel"=>5406.89, "Creditors Control Account"=>1537.79, "Misc Motor expenses"=>38762.3})
        expect(vs_populated.data[:description][:cp]).to eq({"Opening Balances co 1"=>92859.57, "Opening Balances co 2"=>47939.46, "YE trial balance co 1"=>128614.69, "YE trial balance co 2"=>84750.44, "Opening Balances co 3"=>46209.83, "YE trial balance co 3"=>73255.39})
      end
      it 'can load show page VIEW data structure' do
        vs_populated.load_show_page
        expect(vs_populated.data[:mitag_summary][:pp]).to eq({"Savings account"=>12768.65, "Casual labour"=>17288.81, "Professional Fees"=>22406.81, "Rent"=>9365.76, "Output VAT"=>14869.58, "PnL CY"=>15793.99, "Sales stream 5"=>9446.61, "Client disbursements"=>18831.76, "CT liability"=>14086.24, "Cleaning"=>13385.03, "Premises expenses"=>12201.98, "Fixtures and Fittings - depn charge"=>10822.84, "Directors loan"=>15584.57, "Input VAT"=>14067.27, "Electricty"=>3111.38, "Fixtures and Fittings - cost"=>11413.87, "Sales stream 6"=>129.07, "Debtors Control Account"=>13503.4, "Recruitment expenses"=>11100.24, "Training costs"=>-1081.27, "Sales stream 7"=>9210.88, "Prepayments"=>5489.98, "Current account"=>1247.84, "Audit and accounting fees"=>622.56, "Fixtures and Fittings - additions"=>12214.45, "Share capital"=>13491.05, "Accruals & other creditors"=>14185.8, "Fixtures and Fittings - acc depn"=>2772.92, "Dividend Paid"=>13985.04, "Petty Cash"=>18303.58, "VAT Control"=>5245.14, "Advertising"=>16976.96, "Refreshments"=>-16912.54, "Insurance"=>-11833.51, "Sales stream 9"=>17912.64, "Sales stream 10"=>7199.12, "Sales stream 11"=>6968.15, "Sales stream 8"=>9004.27, "Directors salaries"=>3023.7, "Travel"=>-1121.75, "Creditors Control Account"=>3383.22, "Misc Motor expenses"=>-9331.17})
        expect(vs_populated.data[:description][:pp]).to eq({"Opening Balances co 1"=>107142.02, "Opening Balances co 2"=>58084.38, "YE trial balance co 1"=>75621.94, "YE trial balance co 2"=>39358.27, "Opening Balances co 3"=>48003.04, "YE trial balance co 3"=>32925.28})
      end
    end
    # END OF PIVOT CONTROL CONTEXT
    context "ETB values and setting data" do
      before do
        5.times do 
            report.values << FactoryGirl.create(:etb_value, description: "Being JNL 1", repdate: Date.new(2014, 12, 01))
        end
        5.times do 
            report.values << FactoryGirl.create(:etb_value, description: "Being JNL 2", repdate: Date.new(2013, 12, 01))
        end
      end
      let(:vs_populated) { ReportsValueService.new(report) }

      it 'has etb values' do
        expect(report.etb_values.count).to eq 10
      end
      it 'sets c_value p_value for etb values' do
        vs_populated.set_stat_values_etb
        expect(vs_populated.data[:c_period_values_etb]).to eq( report.get_values_for(report.current_end, 'EtbValue') )
      end
      it 'sets p_value p_value for etb values' do
        vs_populated.set_stat_values_etb
        expect(vs_populated.data[:p_period_values_etb]).to eq( report.get_values_for(report.comparative_end, 'EtbValue') )
      end
      it 'can set show summary pivot data' do
        vs_populated.set_stat_values_etb
        result = vs_populated.set_show_summary_pivot_etb
        expect(vs_populated.data[:mitag_summary][:cp_etb]).to eq( {"miTag from user"=>49.95})
        expect(vs_populated.data[:description][:cp_etb]).to eq({"Being JNL 1"=>49.95})
      end
      it 'can load show page VIEW data structure' do
        vs_populated.load_show_page
        expect(vs_populated.data[:mitag_summary][:cp_etb]).to eq( {"miTag from user"=>49.95})
        expect(vs_populated.data[:description][:pp_etb]).to eq({"Being JNL 2"=>49.95})
      end
    end
    # end of etb context


end
