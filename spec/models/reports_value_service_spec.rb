require 'rails_helper'

describe ReportsValueService do

    before { Report.any_instance.stub(:build_back_end) } 

    let(:report) { FactoryGirl.create(:report) }

    let(:vs_empty) { ReportsValueService.new(report) }
    #let(:csv_file) { Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/report_values.csv") }
    let(:file) { "#{Rails.root}/spec/fixtures/current_and_prior.csv" }
    let(:better_file) { "#{Rails.root}/files/welcome_rep_gaap.csv" }
    let(:welcome_ifrs) { "#{Rails.root}/files/welcome_rep.csv" }
    
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

    context "pivot control welcomeIFRS" do
      before do
        report.parse_csv_and_book(File.open(welcome_ifrs))
      end
      let(:vs_populated) { ReportsValueService.new(report) }

      it 'can retrieve correctly current year end values' do
        expect(vs_populated.get_cye_values.count).to eq 152
      end
      it 'can retrieve correctly comparative end values' do
        expect(vs_populated.get_pye_values.count).to eq 151
      end
      it 'can set data' do
        vs_populated.set_stat_values
        expect(vs_populated.data[:c_period_values].count).to eq 152
        expect(vs_populated.data[:p_period_values].count).to eq 151
      end
      it 'can summarise by mitag and sum amount' do
        values = vs_populated.get_cye_values
        summarised = vs_populated.summarise_by_mitag { values }
        result = {}
        summarised.each do |t|
          result["#{t.mitag}"] = t.sum.to_f
        end
        expect(result).to eq({"Savings account"=>11375.6807069, "Casual labour"=>7836.281727, "Professional Fees"=>162.01986061, "Trading with china futures"=>12451.0, "Rent"=>10371.8652531, "Output VAT"=>5649.020964, "PnL CY"=>12359.908581, "Sales stream 5"=>21423.476005, "Client disbursements"=>11276.555176, "CT liability"=>19558.232719, "Cleaning"=>7497.414382, "HP 2"=>50000.0, "Cash savings 1"=>2000000.0, "Overhead 3 4 5"=>13806.0, "HP 3"=>50000.0, "Fixtures and Fittings - depn charge"=>4145.3622732, "Directors loan"=>10322.508061, "Input VAT"=>945.85125101, "Fixtures and Fittings - cost"=>8108.7467258, "HP 1"=>50000.0, "Trading with india GBP mvts"=>8270.833333, "FTSE 100"=>12451.0, "Debtors Control Account"=>3263.2518153, "Overhead 1 2 and 3"=>12451.0, "Fixtures and Fittings - additions"=>23206.902174, "Share capital"=>9962.064877, "Accruals & other creditors"=>12832.607397, "Fixtures and Fittings - acc depn"=>13077.282042, "Loan Bank 2"=>500000.0, "Petty Cash"=>8541.3304706, "VAT Control"=>15940.661211, "Advertising"=>5940.04525857, "Sales stream 9"=>19105.552159, "Trading with china GBP mvts"=>-6648.333333, "Bad debtors"=>43132.0, "Sales stream 8"=>20366.441131, "Directors salaries"=>107.41667617, "Travel"=>3441.24848532, "Creditors Control Account"=>2064.0631168, "Misc Motor expenses"=>38570.173619, "Premises expenses"=>11575.207227, "Loan Bank 1"=>500000.0, "Trading with india futures"=>1255.0, "NASDAQ"=>1255.0, "Electricty"=>5044.7898215, "Investment account"=>1560000.0, "Sales stream 6"=>13850.704416, "Trading with USA GBP mvts"=>9893.333333, "Recruitment expenses"=>14487.685032, "Training costs"=>18090.40675, "Sales stream 7"=>6073.322926, "Prepayments"=>8490.5750875, "Current account"=>2501.4623191, "Audit and accounting fees"=>10930.395953, "Working capital account"=>321022.0, "Dividend Paid"=>1938.60174931, "Trading with USA futures"=>12551.0, "Refreshments"=>6935.8694144, "Insurance"=>10458.563418, "Sales stream 10"=>13094.738147, "Sales stream 11"=>13620.168374})
      end
      it 'can set show summary pivot data' do
        vs_populated.set_stat_values
        result = vs_populated.set_show_summary_pivot
        expect(vs_populated.data[:mitag_summary][:cp]).to eq({"Savings account"=>11375.68, "Casual labour"=>7836.28, "Professional Fees"=>162.02, "Trading with china futures"=>12451.0, "Rent"=>10371.87, "Output VAT"=>5649.02, "PnL CY"=>12359.91, "Sales stream 5"=>21423.48, "Client disbursements"=>11276.56, "CT liability"=>19558.23, "Cleaning"=>7497.41, "HP 2"=>50000.0, "Cash savings 1"=>2000000.0, "Overhead 3 4 5"=>13806.0, "HP 3"=>50000.0, "Fixtures and Fittings - depn charge"=>4145.36, "Directors loan"=>10322.51, "Input VAT"=>945.85, "Fixtures and Fittings - cost"=>8108.75, "HP 1"=>50000.0, "Trading with india GBP mvts"=>8270.83, "FTSE 100"=>12451.0, "Debtors Control Account"=>3263.25, "Overhead 1 2 and 3"=>12451.0, "Fixtures and Fittings - additions"=>23206.9, "Share capital"=>9962.06, "Accruals & other creditors"=>12832.61, "Fixtures and Fittings - acc depn"=>13077.28, "Loan Bank 2"=>500000.0, "Petty Cash"=>8541.33, "VAT Control"=>15940.66, "Advertising"=>5940.05, "Sales stream 9"=>19105.55, "Trading with china GBP mvts"=>-6648.33, "Bad debtors"=>43132.0, "Sales stream 8"=>20366.44, "Directors salaries"=>107.42, "Travel"=>3441.25, "Creditors Control Account"=>2064.06, "Misc Motor expenses"=>38570.17, "Premises expenses"=>11575.21, "Loan Bank 1"=>500000.0, "Trading with india futures"=>1255.0, "NASDAQ"=>1255.0, "Electricty"=>5044.79, "Investment account"=>1560000.0, "Sales stream 6"=>13850.7, "Trading with USA GBP mvts"=>9893.33, "Recruitment expenses"=>14487.69, "Training costs"=>18090.41, "Sales stream 7"=>6073.32, "Prepayments"=>8490.58, "Current account"=>2501.46, "Audit and accounting fees"=>10930.4, "Working capital account"=>321022.0, "Dividend Paid"=>1938.6, "Trading with USA futures"=>12551.0, "Refreshments"=>6935.87, "Insurance"=>10458.56, "Sales stream 10"=>13094.74, "Sales stream 11"=>13620.17})
        expect(vs_populated.data[:description][:cp]).to eq({"Opening Balances co 1"=>1135991.57, "Opening Balances co 2"=>3915459.15, "Finance lease mvmts"=>150000.0, "Hedging items not on TB"=>26257.0, "Opening Balances co 3"=>46987.39, "Co 1, 2 and 3 direct overheads"=>26257.0, "YE trial balance co 3"=>74893.73, "Opening FX mvmts BS"=>11515.83, "Not in TB shares"=>13706.0, "YE trial balance co 1"=>128614.69, "YE trial balance co 2"=>66751.92})
      end
      it 'can load show page VIEW data structure' do
        vs_populated.load_show_page
        expect(vs_populated.data[:mitag_summary][:pp]).to eq({"Savings account"=>12868.41, "Casual labour"=>25233.7, "Professional Fees"=>17048.33, "Trading with china futures"=>50021.0, "Rent"=>11036.79, "Output VAT"=>15421.48, "PnL CY"=>17086.92, "Sales stream 5"=>9519.05, "Client disbursements"=>12534.15, "Trading with USA GBP mvmts"=>4567.0, "CT liability"=>20210.61, "Cleaning"=>18747.89, "HP 2"=>75000.0, "Cash savings 1"=>1000000.0, "Overhead 3 4 5"=>12340.0, "HP 3"=>75000.0, "Fixtures and Fittings - depn charge"=>7822.05, "Directors loan"=>14893.56, "Input VAT"=>15044.07, "Fixtures and Fittings - cost"=>13218.64, "HP 1"=>75000.0, "FTSE 100"=>50021.0, "Debtors Control Account"=>17431.17, "Trading with china GBP acc mvmts"=>-1322.0, "Trading with india GBP mvmts"=>4321.0, "Overhead 1 2 and 3"=>50021.0, "Fixtures and Fittings - additions"=>15901.26, "Share capital"=>12427.27, "Accruals & other creditors"=>11671.54, "Fixtures and Fittings - acc depn"=>1699.85, "Loan Bank 2"=>600000.0, "Petty Cash"=>15380.08, "VAT Control"=>5792.69, "Advertising"=>18949.7, "Sales stream 9"=>17596.71, "Sales stream 10"=>8383.19, "Sales stream 11"=>5631.27, "Bad debtors"=>43132.0, "Sales stream 8"=>6296.25, "Directors salaries"=>3134.04, "Travel"=>6428.26, "Creditors Control Account"=>3593.57, "Misc Motor expenses"=>-2482.87, "Premises expenses"=>15375.18, "Loan Bank 1"=>600000.0, "Trading with india futures"=>12340.0, "NASDAQ"=>12340.0, "Electricty"=>3084.17, "Investment account"=>1233332.0, "Sales stream 6"=>137.68, "Recruitment expenses"=>11778.6, "Training costs"=>-961.57, "Sales stream 7"=>6994.69, "Prepayments"=>6126.9, "Current account"=>1086.88, "Audit and accounting fees"=>413.41, "Working capital account"=>543000.0, "Dividend Paid"=>17303.25, "Trading with USA futures"=>67812.0, "Refreshments"=>-16958.8, "Insurance"=>-12525.71})
        expect(vs_populated.data[:description][:pp]).to eq({"Opening Balances co 1"=>1350274.02, "Opening Balances co 2"=>2834054.9, "Finance lease mvmts"=>225000.0, "Hedging items not on TB"=>130173.0, "Opening Balances co 3"=>60115.27, "Co 1, 2 and 3 direct overheads"=>62361.0, "YE trial balance co 3"=>41462.76, "Opening FX mvmts BS"=>7566.0, "Not in TB shares"=>62361.0, "YE trial balance co 1"=>75621.94, "YE trial balance co 2"=>48309.41})
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
        expect(result).to eq({"Savings account"=>17007.971553, "Casual labour"=>7225.1342608, "Professional Fees"=>189.18773585, "Rent"=>11721.56085, "Output VAT"=>6570.015831, "PnL CY"=>16097.593982, "Sales stream 5"=>18944.93594, "Client disbursements"=>11769.227235, "Cleaning"=>7048.553913, "CT liability"=>14198.703469, "Premises expenses"=>9496.571334, "Fixtures and Fittings - depn charge"=>3178.41654629, "Directors loan"=>10335.3602557, "Electricty"=>7236.2600098, "Input VAT"=>864.29836259, "Fixtures and Fittings - cost"=>12148.37921, "Sales stream 6"=>73254.285243, "Debtors Control Account"=>3893.0114682, "Recruitment expenses"=>16836.737607, "Training costs"=>22873.603575, "Sales stream 7"=>9455.416347, "Audit and accounting fees"=>11834.878892, "Current account"=>2189.7475524, "Prepayments"=>15878.951103, "Fixtures and Fittings - additions"=>15146.3380142, "Share capital"=>11993.354117, "Accruals & other creditors"=>7016.0189032, "Dividend Paid"=>3752.9764966, "Fixtures and Fittings - acc depn"=>18369.215613, "Advertising"=>9410.851151, "Petty Cash"=>11805.98937636, "Refreshments"=>7722.3718289, "VAT Control"=>15024.736538, "Insurance"=>11790.985484, "Sales stream 10"=>8061.3745037, "Sales stream 11"=>17373.46603, "Sales stream 9"=>16658.905411, "Sales stream 8"=>22242.10665, "Directors salaries"=>162.32356431, "Travel"=>5406.8924091, "Creditors Control Account"=>1537.7852659, "Misc Motor expenses"=>38762.297001})
      end
      it 'can set show summary pivot data' do
        vs_populated.set_stat_values
        result = vs_populated.set_show_summary_pivot
        expect(vs_populated.data[:mitag_summary][:cp]).to eq({"Savings account"=>17007.97, "Casual labour"=>7225.13, "Professional Fees"=>189.19, "Rent"=>11721.56, "Output VAT"=>6570.02, "PnL CY"=>16097.59, "Sales stream 5"=>18944.94, "Client disbursements"=>11769.23, "Cleaning"=>7048.55, "CT liability"=>14198.7, "Premises expenses"=>9496.57, "Fixtures and Fittings - depn charge"=>3178.42, "Directors loan"=>10335.36, "Electricty"=>7236.26, "Input VAT"=>864.3, "Fixtures and Fittings - cost"=>12148.38, "Sales stream 6"=>73254.29, "Debtors Control Account"=>3893.01, "Recruitment expenses"=>16836.74, "Training costs"=>22873.6, "Sales stream 7"=>9455.42, "Audit and accounting fees"=>11834.88, "Current account"=>2189.75, "Prepayments"=>15878.95, "Fixtures and Fittings - additions"=>15146.34, "Share capital"=>11993.35, "Accruals & other creditors"=>7016.02, "Dividend Paid"=>3752.98, "Fixtures and Fittings - acc depn"=>18369.22, "Advertising"=>9410.85, "Petty Cash"=>11805.99, "Refreshments"=>7722.37, "VAT Control"=>15024.74, "Insurance"=>11790.99, "Sales stream 10"=>8061.37, "Sales stream 11"=>17373.47, "Sales stream 9"=>16658.91, "Sales stream 8"=>22242.11, "Directors salaries"=>162.32, "Travel"=>5406.89, "Creditors Control Account"=>1537.79, "Misc Motor expenses"=>38762.3})
        expect(vs_populated.data[:description][:cp]).to eq({"Opening Balances co 1"=>92859.57, "Opening Balances co 2"=>47939.46, "YE trial balance co 1"=>187472.1, "YE trial balance co 2"=>84750.44, "Opening Balances co 3"=>46209.83, "YE trial balance co 3"=>73255.39})
      end
      it 'can load show page VIEW data structure' do
        vs_populated.load_show_page
        expect(vs_populated.data[:mitag_summary][:pp]).to eq({"Savings account"=>12768.65, "Casual labour"=>17288.81, "Professional Fees"=>22406.81, "Rent"=>9365.76, "Output VAT"=>14869.58, "PnL CY"=>17153.64, "Sales stream 5"=>8086.96, "Client disbursements"=>18831.76, "Cleaning"=>13385.03, "CT liability"=>14086.24, "Premises expenses"=>12201.98, "Fixtures and Fittings - depn charge"=>10822.84, "Directors loan"=>15584.57, "Electricty"=>3111.38, "Input VAT"=>14067.27, "Fixtures and Fittings - cost"=>11413.87, "Sales stream 6"=>50207.94, "Debtors Control Account"=>13503.4, "Recruitment expenses"=>11100.24, "Training costs"=>-1081.27, "Sales stream 7"=>9210.88, "Audit and accounting fees"=>622.56, "Current account"=>1247.84, "Prepayments"=>5489.98, "Fixtures and Fittings - additions"=>12214.45, "Share capital"=>13491.05, "Accruals & other creditors"=>14185.8, "Dividend Paid"=>13985.04, "Fixtures and Fittings - acc depn"=>2772.92, "Advertising"=>16976.96, "Petty Cash"=>18303.58, "Refreshments"=>-16912.54, "VAT Control"=>5245.14, "Insurance"=>-11833.51, "Sales stream 10"=>7199.12, "Sales stream 11"=>6968.15, "Sales stream 9"=>17912.64, "Sales stream 8"=>9004.27, "Directors salaries"=>3023.7, "Travel"=>-1121.75, "Creditors Control Account"=>3383.22, "Misc Motor expenses"=>-9331.17})
        expect(vs_populated.data[:description][:pp]).to eq({"Opening Balances co 1"=>107142.02, "Opening Balances co 2"=>58084.38, "YE trial balance co 1"=>75621.94, "YE trial balance co 2"=>39358.27, "Opening Balances co 3"=>48003.04, "YE trial balance co 3"=>83004.15})
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
