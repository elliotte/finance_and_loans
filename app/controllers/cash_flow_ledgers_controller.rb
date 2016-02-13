class CashFlowLedgersController < ApplicationController
	
	def show
	    @ledger = CashFlowLedger.find(params[:id])
	    #change cf settings column to assumptions			
	    @settings = JSON.parse(@ledger.cf_settings).symbolize_keys	    
	end

	def fetch_cf_data_input_form; end

	private

	def set_ledger
		@ledger = CashFlowLedger.find(params[:id])
	end

end