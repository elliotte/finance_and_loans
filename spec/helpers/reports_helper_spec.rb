require 'rails_helper'

describe ReportHelper do

	let(:file_cy) { "#{Rails.root}/spec/fixtures/cy_reportCSV.csv" }
	let(:file_py) { "#{Rails.root}/spec/fixtures/py_reportCSV.csv" }
    let(:values_hash_cy) { ParseValuesCSV.new(file_cy).return_data }
    let(:values_hash_py) { ParseValuesCSV.new(file_py).return_data }
    let(:report) { FactoryGirl.create(:report) }
    before do 
      report.book_values(values_hash_cy)
      report.book_values(values_hash_py)
    end
    let(:rp_dash_s) { ReportsDashService.new(report) }
    let(:data) { rp_dash_s.load_data }

	describe "ifrs_dash view helper methods" do
		before do 
			@data = data
		end
		it 'can can find income stat tag in cy data' do
			expect(find_data("Revenue", :cy)).to eq({:lv_1=>"Revenue", :lv_2=>"GP_Rev", :amount=>245026.2923463})
		end
		it 'can can find income stat tag in py data' do
			expect(find_data("Revenue", :py)).to eq({:lv_1=>"Revenue", :lv_2=>"GP_Rev", :amount=>224323.2923463})
		end
		it 'can return a cy found amount' do
			amt = yield_amount { find_data("Revenue", :cy) }
			expect(amt).to eq 245026.29
		end
		it 'can return absolute py found amount' do
			amt = yield_amount { find_data("Cost of sales", :py) }
			expect(amt).to eq 227000.22
		end
	    it 'can calculate margins with numerator nil' do
	    	expect(calc_margin(0,1)).to eq "0%"
	    end

	 #    it 'returns IFRS stat view display of amount' do
	 #    	expect(display_ifrs(10213.1231231)).to eq 10213
	 #    end
	 #    it 'returns IFRS stat view display of nil amounts' do
	 #    	expect(display_ifrs(nil)).to eq 0.00
	 #    end
	 #    it 'returns IFRS stat view display of string amount' do
	 #    	expect(display_ifrs("---")).to eq 0.00
	 #    end
	 #    it 'returns negative amounts as brackets' do
	 #    	expect(display_ifrs(-100)).to eq "(100)"
	 #    end
	 #    it 'returns negative amounts as brackets' do
	 #    	expect(display_ifrs(-0.5)).to eq "(1)"
	 #    end
	 #    it 'returns negative amounts as brackets' do
	 #    	expect(display_ifrs(0.5)).to eq 1
	 #    end




  	end

end
