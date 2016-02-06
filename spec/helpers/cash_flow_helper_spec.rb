require "spec_helper"

describe CashFlowHelper do
  
  context "fetch columns for CF View" do
    it "returns 12" do
      @settings = {format: {"cf_length"=> "Full-Year"} }
    	expect(fetch_columns).to eq(12)
    end
    it "returns 6" do
      @settings = {format: {"cf_length"=> "Half-Year"} }
      expect(fetch_columns).to eq(6)
    end
    it "returns 1" do
      @settings = {format: {"cf_length"=> "Annual"} }
      expect(fetch_columns).to eq(3)
    end
  end
  context "dates from settings hash" do
    it "returns Date object" do
      @settings = {format: {"start_month"=> "January"} }
      expect(create_date).to be_a Date
    end
     it "returns Date object" do
      @settings = {format: {"start_month"=> "January"} }
      expect(create_date.strftime("%B %Y")).to eq("January 2016")
    end
  end
  
end