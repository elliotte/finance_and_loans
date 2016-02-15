class CashFlowLedgersController < ApplicationController
	before_filter :set_ledger

	def show
	    #change cf settings column to assumptions			
	    @settings = @ledger.cf_settings.symbolize_keys    
	end

	def fetch_cf_data_input_form; end

	def update_cf_settings
		@ledger.cf_settings["format"][params["format"].keys.first]= params["format"].values.first
		@ledger.save
	end

	def edit_cf_settings;end

	private

	def set_ledger
		@ledger = CashFlowLedger.find(params[:id])
	end

end