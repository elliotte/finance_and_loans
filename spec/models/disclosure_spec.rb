require 'rails_helper'

describe Disclosure do

    before do 
      Report.any_instance.stub(:build_back_end)
    end

    it { should belong_to :report }
    it { should respond_to :body }
    it { should respond_to :type }
    it { should respond_to :title }
    it { should respond_to :active }
    it { should respond_to :added_by }

    context "in app use" do
    	it 'can initialise GlobalReport type' do
    		expect { Disclosure.new(type: 'GlobalReport') }.not_to raise_error
    	end
    	it 'can initialise DirectorReport type' do
    		expect { Disclosure.new(type: 'DirectorReport') }.not_to raise_error
    	end
    	it 'doesnt initialise invalid' do
    		expect { Disclosure.new(type: 'NaeChance') }.to raise_error
    	end
    end
    context "disclosure Coding Control" do
      it 'can load global user select TYPE options' do
      		expect(Disclosure.global_type_options).to eq ["GlobalReport", "DirectorReport"]
      	end
  		it 'can load global ifrs disclosures vars' do
  			expect(Disclosure.global_ifrs_vars).to eq({:company_name=>["Disclosure", "Company name"], :business_year_end=>["Disclosure", "Year end"], :director_1=>["Disclosure", "Directors"], :director_2=>["Disclosure", "Directors"], :director_3=>["Disclosure", "Directors"], :secretary=>["Disclosure", "Secretary"], :registered_office=>["Disclosure", "Registered Office"], :auditor=>["Disclosure", "Auditor"], :country_residence=>["Disclosure", "Registered in"]})
  		end
  		it 'can load example ifrs txt body' do
  			expect(Disclosure.ifrs_example_body_txt).to eq({"Global"=>{"company_name"=>"Example Company Name Ltd", "director_1"=>"Director Name 1", "director_2"=>"Director Name 2", "director_3"=>"Director Name 3", "secretary"=>"Example Name", "registered_office"=>"1 Office Address", "auditor"=>"Accountants LLP", "country_residence"=>"England", "business_year_end"=>"December 2014"}, "DirectorReport"=>{"change_of_name_from"=>"Before Name Ltd", "change_of_name_after"=>"After Name Ltd", "principal_activity"=>"Distribution of products to customers", "revenue_current"=>10000, "revenue_prior"=>9000, "profit_current"=>3000, "profit_prior"=>2000, "dividend_current"=>500, "dividend_prior"=>500, "assets_current"=>40000, "assets_prior"=>37000, "equity_current"=>5000, "equity_prior"=>4000}})
  		end
  		it 'has matching amt of global keys and example txt keys' do
  			text = Disclosure.ifrs_example_body_txt
  			global_vars = Disclosure.global_ifrs_vars
  			text_tags = text[:Global].symbolize_keys.keys
  			count = 0
  			wrong = []

  			text_tags.each do |key|
  				if global_vars.has_key?(key)
  					count += 1
  				else
  					wrong << key
  				end
  			end
  			expect(count).to eq 9
  			expect(wrong).to eq []
  			expect(global_vars.keys.count).to eq 9
  			expect(text_tags.count).to eq 9
  		end
	end

  context 'class methods' do
    before do
      @report = FactoryGirl.create(:report)
      5.times{FactoryGirl.create(:disclosure, report_id: @report.id)}
    end
    describe 'export_data' do
      it 'returns data for all records' do
        expect(Disclosure.export_data(:all, @report)).to eq(@report.disclosures)
      end

      it 'returns data for current records' do
        expect(Disclosure.export_data(:current, @report)).to eq(@report.disclosures.where(created_at: @report.current_end))
      end
    end
  end

end
