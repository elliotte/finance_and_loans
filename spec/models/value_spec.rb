require 'rails_helper'

context "Control" do
	
	before { Report.any_instance.stub(:build_back_end) }

	describe Value, "Associations" do
		it { should belong_to :report } 
		it { should validate_presence_of :repdate }
	end

	describe Value, "Scopes" do
		let(:report_populated) do
			FactoryGirl.create(:report_with_values_this_month)
		end
		it 'should respond to its tbvalues' do
			expect(report_populated.values).to respond_to :tbvalues
		end
		it 'should respond to its etbvalues' do
			expect(report_populated.values).to respond_to :etbvalues
		end
	end

	describe Value, "when saved" do
		it 'should not have a blank ifrstag' do
			v = Value.create(:amount => 1.00, :repdate => Time.now )
	    	v.ifrstag.should_not be_blank
		end	
		it 'should default ifrstag to No-Mapping' do
			v = Value.create(:amount => 1.00, :repdate => Time.now )
	    	v.ifrstag.should == "No-Mapping"
		end	
	end

end