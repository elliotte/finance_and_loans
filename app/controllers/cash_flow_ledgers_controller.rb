class CashFlowLedgersController < ApplicationController
	
	def show
	    @ledger = CashFlowLedger.find(params[:id])			
	    @settings = JSON.parse(@ledger.cf_settings).symbolize_keys
	end

end