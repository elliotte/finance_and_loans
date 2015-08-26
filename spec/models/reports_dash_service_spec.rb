require 'rails_helper'

describe ReportsDashService do

    before do 
      Report.any_instance.stub(:build_back_end)
    end

    let(:file) { "#{Rails.root}/spec/fixtures/report_values.csv" }
    let(:file_gaap) { "#{Rails.root}/spec/fixtures/report_values_gaap.csv" }

    let(:values_hash) { ParseValuesCSV.new(file).return_data }
    let(:gaap_values_hash) { ParseValuesCSV.new(file_gaap, 'UKGAAP').return_data }
    let(:report) { FactoryGirl.create(:report) }
    let(:gaap_report) { FactoryGirl.create(:report, format: 'UKGAAP', current_end: Date.new(2014,12,12), comparative_end: Date.new(2013,12,12)) }

    it 'should not initialise without a file' do
      expect { ReportsDashService.new }.to raise_error
    end
    it 'should initialise successfully with a client' do
      expect { ReportsDashService.new(report) }.not_to raise_error
    end

    context "IFRS structured data" do

        let(:rp_dash_s) { ReportsDashService.new(report)}

        before do 
          report.book_values(values_hash)
        end
        it 'report should have monea-tagged values' do
            expect(report.values.last.ifrstag).to eq "No-Mapping"
            expect(report.values[9].ifrstag).to eq "Revenue"
        end
        it 'should have 58 report values' do
            expect(report.values.count).to eq 313
        end
        it 'can get the values for the report periods' do
          a = rp_dash_s.get_cye_values
          b = rp_dash_s.get_pye_values
          expect(a.count).to eq 157
          expect(b.count).to eq 156
        end
        it 'expects summarise call' do
          report.stub(:summarise_by_ifrs).and_return({})
          expect(report).to receive(:summarise_by_ifrs)
          rp_dash_s.group_cy
        end
        it 'can group cy values' do
          a = rp_dash_s.group_cy
          expect(a).to eq( [{:lv_1=>"Distribution expenses", :lv_2=>"op_cos", :amount=>-19487.285348}, {:lv_1=>"Income Tax Payable", :lv_2=>"cl", :amount=>2617782.0635}, {:lv_1=>"Investment property", :lv_2=>"nca", :amount=>1425137.0045}, {:lv_1=>"Cost of sales", :lv_2=>"gp_cos", :amount=>-239166.2246494}, {:lv_1=>"Inventories", :lv_2=>"ca", :amount=>5800039.437}, {:lv_1=>"Cash and cash equivalents", :lv_2=>"ca", :amount=>5178010.3996}, {:lv_1=>"No-Mapping", :lv_2=>"eq", :amount=>5886224.410704}, {:lv_1=>"Share capital", :lv_2=>"eq", :amount=>2174181.48698}, {:lv_1=>"Retained earnings", :lv_2=>"eq", :amount=>2346550.4457}, {:lv_1=>"Loans and borrowings", :lv_2=>"cl", :amount=>3662618.14108}, {:lv_1=>"Trade and other payables", :lv_2=>"cl", :amount=>473044.97519}, {:lv_1=>"Revenue", :lv_2=>"gp_rev", :amount=>245026.2923463}])
        end
        it 'expects summarise call' do
          report.stub(:summarise_by_ifrs).and_return({})
          expect(report).to receive(:summarise_by_ifrs)
          rp_dash_s.group_py
        end
        it 'can group py values' do
          a = rp_dash_s.group_py
          expect(a).to eq( [{:lv_1=>"Distribution expenses", :lv_2=>"op_cos", :amount=>-19487.285348}, {:lv_1=>"Income Tax Payable", :lv_2=>"cl", :amount=>2617782.0635}, {:lv_1=>"Investment property", :lv_2=>"nca", :amount=>1425137.0045}, {:lv_1=>"Cost of sales", :lv_2=>"gp_cos", :amount=>-227000.2246494}, {:lv_1=>"Inventories", :lv_2=>"ca", :amount=>5800039.437}, {:lv_1=>"Cash and cash equivalents", :lv_2=>"ca", :amount=>5178010.3996}, {:lv_1=>"No-Mapping", :lv_2=>"eq", :amount=>5522638.106204}, {:lv_1=>"Share capital", :lv_2=>"eq", :amount=>2174181.48698}, {:lv_1=>"Retained earnings", :lv_2=>"eq", :amount=>2346550.4457}, {:lv_1=>"Loans and borrowings", :lv_2=>"cl", :amount=>3662618.14108}, {:lv_1=>"Trade and other payables", :lv_2=>"cl", :amount=>473044.97519}, {:lv_1=>"Revenue", :lv_2=>"gp_rev", :amount=>224323.2923463}])
        end
        it 'can return summarise data' do
          a = rp_dash_s.load_data
          expect(a).to eq({:cy=>[{:lv_1=>"Distribution expenses", :lv_2=>"op_cos", :amount=>-19487.285348}, {:lv_1=>"Income Tax Payable", :lv_2=>"cl", :amount=>2617782.0635}, {:lv_1=>"Investment property", :lv_2=>"nca", :amount=>1425137.0045}, {:lv_1=>"Cost of sales", :lv_2=>"gp_cos", :amount=>-239166.2246494}, {:lv_1=>"Inventories", :lv_2=>"ca", :amount=>5800039.437}, {:lv_1=>"Cash and cash equivalents", :lv_2=>"ca", :amount=>5178010.3996}, {:lv_1=>"No-Mapping", :lv_2=>"eq", :amount=>5886224.410704}, {:lv_1=>"Share capital", :lv_2=>"eq", :amount=>2174181.48698}, {:lv_1=>"Retained earnings", :lv_2=>"eq", :amount=>2346550.4457}, {:lv_1=>"Loans and borrowings", :lv_2=>"cl", :amount=>3662618.14108}, {:lv_1=>"Trade and other payables", :lv_2=>"cl", :amount=>473044.97519}, {:lv_1=>"Revenue", :lv_2=>"gp_rev", :amount=>245026.2923463}], :py=>[{:lv_1=>"Distribution expenses", :lv_2=>"op_cos", :amount=>-19487.285348}, {:lv_1=>"Income Tax Payable", :lv_2=>"cl", :amount=>2617782.0635}, {:lv_1=>"Investment property", :lv_2=>"nca", :amount=>1425137.0045}, {:lv_1=>"Cost of sales", :lv_2=>"gp_cos", :amount=>-227000.2246494}, {:lv_1=>"Inventories", :lv_2=>"ca", :amount=>5800039.437}, {:lv_1=>"Cash and cash equivalents", :lv_2=>"ca", :amount=>5178010.3996}, {:lv_1=>"No-Mapping", :lv_2=>"eq", :amount=>5522638.106204}, {:lv_1=>"Share capital", :lv_2=>"eq", :amount=>2174181.48698}, {:lv_1=>"Retained earnings", :lv_2=>"eq", :amount=>2346550.4457}, {:lv_1=>"Loans and borrowings", :lv_2=>"cl", :amount=>3662618.14108}, {:lv_1=>"Trade and other payables", :lv_2=>"cl", :amount=>473044.97519}, {:lv_1=>"Revenue", :lv_2=>"gp_rev", :amount=>224323.2923463}]})
        end
    end

    context "returning UKGAAP structured data" do
        
        let(:gaap_dash_s) { ReportsDashService.new(gaap_report)}
        
        before do 
          gaap_report.book_values(gaap_values_hash)
        end
        it 'report should have monea-tagged values' do
            monea_tags = gaap_report.values.map{|v| v.ifrstag }.uniq
            expect(monea_tags).to eq  ["Plant & machinery cost - b/fwd", "Plant & machinery cost - additions", "Plant & machinery cost - disposals", "Plant & machinery depn - b/fwd", "Trade debtors", "Other debtors", "Cash in hand", "Trade creditors", "Accruals and deferred sales", "Other creditors", "Other taxes and social security costs", "Ordinary shares", "No-Mapping", "Sales", "Advertising and PR", "Directors' salaries", "Purchases", "Commissions payable", "Wages and salaries", "Rent", "Light and heat", "Travel and subsistence", "Accountancy fees", "Cleaning", "Staff training and welfare", "Insurance"]
        end
        it 'should have 58 report values' do
            expect(gaap_report.values.count).to eq 264
        end
        it 'can set values for report period' do
          a = gaap_dash_s.get_cye_values
          b = gaap_dash_s.get_pye_values
          expect(a.count).to eq 132
          expect(b.count).to eq 132
        end
        it 'can group cy values by moneaTag' do
          gaap_report.stub(:summarise_by_ifrs).and_return({})
          expect(gaap_report).to receive(:summarise_by_ifrs)
          gaap_dash_s.group_cy
        end
        it 'can group py values by moneaTag' do
          gaap_report.stub(:summarise_by_ifrs).and_return({})
          expect(gaap_report).to receive(:summarise_by_ifrs)
          gaap_dash_s.group_py
        end
        it 'can group cy values' do
          a = gaap_dash_s.group_cy
          expect(a).to eq([{:lv_1=>"Trade creditors", :lv_2=>"cred_current", :amount=>1537.7852659}, {:lv_1=>"Plant & machinery depn - b/fwd", :lv_2=>"fa_tang", :amount=>3178.41654629}, {:lv_1=>"Directors' salaries", :lv_2=>"op_admin", :amount=>162.32356431}, {:lv_1=>"Rent", :lv_2=>"op_admin", :amount=>11721.56085}, {:lv_1=>"Sales", :lv_2=>"gp_sales", :amount=>107133.0812437}, {:lv_1=>"No-Mapping", :lv_2=>"capital", :amount=>16097.593982}, {:lv_1=>"Commissions payable", :lv_2=>"gp_cos", :amount=>11769.227235}, {:lv_1=>"Purchases", :lv_2=>"gp_cos", :amount=>7225.1342608}, {:lv_1=>"Cleaning", :lv_2=>"op_admin", :amount=>16545.125247}, {:lv_1=>"Travel and subsistence", :lv_2=>"op_admin", :amount=>44169.1894101}, {:lv_1=>"Accountancy fees", :lv_2=>"op_admin", :amount=>12024.06662785}, {:lv_1=>"Other taxes and social security costs", :lv_2=>"cred_current", :amount=>36657.75420059}, {:lv_1=>"Staff training and welfare", :lv_2=>"op_admin", :amount=>22873.603575}, {:lv_1=>"Insurance", :lv_2=>"op_admin", :amount=>19513.3573129}, {:lv_1=>"Trade debtors", :lv_2=>"curr_assets", :amount=>3893.0114682}, {:lv_1=>"Advertising and PR", :lv_2=>"op_admin", :amount=>9410.851151}, {:lv_1=>"Plant & machinery cost - b/fwd", :lv_2=>"fa_tang", :amount=>12148.37921}, {:lv_1=>"Other debtors", :lv_2=>"curr_assets", :amount=>15878.951103}, {:lv_1=>"Accruals and deferred sales", :lv_2=>"cred_current", :amount=>7016.0189032}, {:lv_1=>"Plant & machinery cost - disposals", :lv_2=>"fa_tang", :amount=>18369.215613}, {:lv_1=>"Cash in hand", :lv_2=>"curr_assets", :amount=>31003.70848176}, {:lv_1=>"Plant & machinery cost - additions", :lv_2=>"fa_tang", :amount=>15146.3380142}, {:lv_1=>"Other creditors", :lv_2=>"cred_greater", :amount=>10335.3602557}, {:lv_1=>"Wages and salaries", :lv_2=>"op_admin", :amount=>16836.737607}, {:lv_1=>"Light and heat", :lv_2=>"op_admin", :amount=>7236.2600098}, {:lv_1=>"Ordinary shares", :lv_2=>"capital", :amount=>15746.3306136}])
        end
        it 'can group py values' do
          a = gaap_dash_s.group_py
          expect(a).to eq([{:lv_1=>"Trade creditors", :lv_2=>"cred_current", :amount=>3383.2230561}, {:lv_1=>"Plant & machinery depn - b/fwd", :lv_2=>"fa_tang", :amount=>10822.84106}, {:lv_1=>"Directors' salaries", :lv_2=>"op_admin", :amount=>3023.7033456}, {:lv_1=>"Rent", :lv_2=>"op_admin", :amount=>9365.759973}, {:lv_1=>"Sales", :lv_2=>"gp_sales", :amount=>59870.73483561}, {:lv_1=>"No-Mapping", :lv_2=>"capital", :amount=>15793.991893125}, {:lv_1=>"Commissions payable", :lv_2=>"gp_cos", :amount=>18831.763192}, {:lv_1=>"Purchases", :lv_2=>"gp_cos", :amount=>17288.806038}, {:lv_1=>"Cleaning", :lv_2=>"op_admin", :amount=>25587.0059203}, {:lv_1=>"Travel and subsistence", :lv_2=>"op_admin", :amount=>-10452.91763237}, {:lv_1=>"Accountancy fees", :lv_2=>"op_admin", :amount=>23029.371804}, {:lv_1=>"Other taxes and social security costs", :lv_2=>"cred_current", :amount=>48268.2359684}, {:lv_1=>"Staff training and welfare", :lv_2=>"op_admin", :amount=>-1081.2654074}, {:lv_1=>"Insurance", :lv_2=>"op_admin", :amount=>-28746.048115}, {:lv_1=>"Trade debtors", :lv_2=>"curr_assets", :amount=>13503.395736}, {:lv_1=>"Advertising and PR", :lv_2=>"op_admin", :amount=>16976.956521}, {:lv_1=>"Plant & machinery cost - b/fwd", :lv_2=>"fa_tang", :amount=>11413.86686}, {:lv_1=>"Other debtors", :lv_2=>"curr_assets", :amount=>5489.9768842}, {:lv_1=>"Accruals and deferred sales", :lv_2=>"cred_current", :amount=>14185.804036}, {:lv_1=>"Plant & machinery cost - disposals", :lv_2=>"fa_tang", :amount=>2772.922263}, {:lv_1=>"Cash in hand", :lv_2=>"curr_assets", :amount=>32320.0678811}, {:lv_1=>"Plant & machinery cost - additions", :lv_2=>"fa_tang", :amount=>12214.454106}, {:lv_1=>"Other creditors", :lv_2=>"cred_greater", :amount=>15584.571347}, {:lv_1=>"Wages and salaries", :lv_2=>"op_admin", :amount=>11100.23686}, {:lv_1=>"Light and heat", :lv_2=>"op_admin", :amount=>3111.3833781}, {:lv_1=>"Ordinary shares", :lv_2=>"capital", :amount=>27476.090143}])
        end
        it 'can return summarise data' do
          a = gaap_dash_s.load_data
          expect(a).to eq({:cy=>[{:lv_1=>"Trade creditors", :lv_2=>"cred_current", :amount=>1537.7852659}, {:lv_1=>"Plant & machinery depn - b/fwd", :lv_2=>"fa_tang", :amount=>3178.41654629}, {:lv_1=>"Directors' salaries", :lv_2=>"op_admin", :amount=>162.32356431}, {:lv_1=>"Rent", :lv_2=>"op_admin", :amount=>11721.56085}, {:lv_1=>"Sales", :lv_2=>"gp_sales", :amount=>107133.0812437}, {:lv_1=>"No-Mapping", :lv_2=>"capital", :amount=>16097.593982}, {:lv_1=>"Commissions payable", :lv_2=>"gp_cos", :amount=>11769.227235}, {:lv_1=>"Purchases", :lv_2=>"gp_cos", :amount=>7225.1342608}, {:lv_1=>"Cleaning", :lv_2=>"op_admin", :amount=>16545.125247}, {:lv_1=>"Travel and subsistence", :lv_2=>"op_admin", :amount=>44169.1894101}, {:lv_1=>"Accountancy fees", :lv_2=>"op_admin", :amount=>12024.06662785}, {:lv_1=>"Other taxes and social security costs", :lv_2=>"cred_current", :amount=>36657.75420059}, {:lv_1=>"Staff training and welfare", :lv_2=>"op_admin", :amount=>22873.603575}, {:lv_1=>"Insurance", :lv_2=>"op_admin", :amount=>19513.3573129}, {:lv_1=>"Trade debtors", :lv_2=>"curr_assets", :amount=>3893.0114682}, {:lv_1=>"Advertising and PR", :lv_2=>"op_admin", :amount=>9410.851151}, {:lv_1=>"Plant & machinery cost - b/fwd", :lv_2=>"fa_tang", :amount=>12148.37921}, {:lv_1=>"Other debtors", :lv_2=>"curr_assets", :amount=>15878.951103}, {:lv_1=>"Accruals and deferred sales", :lv_2=>"cred_current", :amount=>7016.0189032}, {:lv_1=>"Plant & machinery cost - disposals", :lv_2=>"fa_tang", :amount=>18369.215613}, {:lv_1=>"Cash in hand", :lv_2=>"curr_assets", :amount=>31003.70848176}, {:lv_1=>"Plant & machinery cost - additions", :lv_2=>"fa_tang", :amount=>15146.3380142}, {:lv_1=>"Other creditors", :lv_2=>"cred_greater", :amount=>10335.3602557}, {:lv_1=>"Wages and salaries", :lv_2=>"op_admin", :amount=>16836.737607}, {:lv_1=>"Light and heat", :lv_2=>"op_admin", :amount=>7236.2600098}, {:lv_1=>"Ordinary shares", :lv_2=>"capital", :amount=>15746.3306136}], :py=>[{:lv_1=>"Trade creditors", :lv_2=>"cred_current", :amount=>3383.2230561}, {:lv_1=>"Plant & machinery depn - b/fwd", :lv_2=>"fa_tang", :amount=>10822.84106}, {:lv_1=>"Directors' salaries", :lv_2=>"op_admin", :amount=>3023.7033456}, {:lv_1=>"Rent", :lv_2=>"op_admin", :amount=>9365.759973}, {:lv_1=>"Sales", :lv_2=>"gp_sales", :amount=>59870.73483561}, {:lv_1=>"No-Mapping", :lv_2=>"capital", :amount=>15793.991893125}, {:lv_1=>"Commissions payable", :lv_2=>"gp_cos", :amount=>18831.763192}, {:lv_1=>"Purchases", :lv_2=>"gp_cos", :amount=>17288.806038}, {:lv_1=>"Cleaning", :lv_2=>"op_admin", :amount=>25587.0059203}, {:lv_1=>"Travel and subsistence", :lv_2=>"op_admin", :amount=>-10452.91763237}, {:lv_1=>"Accountancy fees", :lv_2=>"op_admin", :amount=>23029.371804}, {:lv_1=>"Other taxes and social security costs", :lv_2=>"cred_current", :amount=>48268.2359684}, {:lv_1=>"Staff training and welfare", :lv_2=>"op_admin", :amount=>-1081.2654074}, {:lv_1=>"Insurance", :lv_2=>"op_admin", :amount=>-28746.048115}, {:lv_1=>"Trade debtors", :lv_2=>"curr_assets", :amount=>13503.395736}, {:lv_1=>"Advertising and PR", :lv_2=>"op_admin", :amount=>16976.956521}, {:lv_1=>"Plant & machinery cost - b/fwd", :lv_2=>"fa_tang", :amount=>11413.86686}, {:lv_1=>"Other debtors", :lv_2=>"curr_assets", :amount=>5489.9768842}, {:lv_1=>"Accruals and deferred sales", :lv_2=>"cred_current", :amount=>14185.804036}, {:lv_1=>"Plant & machinery cost - disposals", :lv_2=>"fa_tang", :amount=>2772.922263}, {:lv_1=>"Cash in hand", :lv_2=>"curr_assets", :amount=>32320.0678811}, {:lv_1=>"Plant & machinery cost - additions", :lv_2=>"fa_tang", :amount=>12214.454106}, {:lv_1=>"Other creditors", :lv_2=>"cred_greater", :amount=>15584.571347}, {:lv_1=>"Wages and salaries", :lv_2=>"op_admin", :amount=>11100.23686}, {:lv_1=>"Light and heat", :lv_2=>"op_admin", :amount=>3111.3833781}, {:lv_1=>"Ordinary shares", :lv_2=>"capital", :amount=>27476.090143}]})
        end
    end
    context "service helpers" do
    end
    
end
