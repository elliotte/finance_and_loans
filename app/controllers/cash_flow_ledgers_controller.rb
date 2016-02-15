class CashFlowLedgersController < ApplicationController
	
	before_filter :set_ledger

	def show
	    #change cf settings column to assumptions			
	    @settings = @ledger.cf_settings.symbolize_keys    
	end

	def fetch_cf_data_input_form 
		 @drivers = @ledger.drivers
	end

	def update_cf_settings
		@ledger.cf_settings["format"][ params["format"].keys.first ] = params["format"].values.first
		@ledger.save
	end

	def edit_cf_settings; end

	def update_drivers
		@ledger.drivers.update( params["drivers"] )
		@ledger.save
	end

	private

	def set_ledger
		@ledger = CashFlowLedger.find(params[:id])
	end

end