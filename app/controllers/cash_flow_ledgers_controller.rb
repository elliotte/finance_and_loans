class CashFlowLedgersController < ApplicationController
	
	before_filter :set_ledger

	def show
	    #change cf settings column to assumptions			
	    @settings = @ledger.cf_settings.symbolize_keys
	    transactions = @ledger.transactions
	    #why group by ID?
	    @transactions = transactions.all.group([:id, :mi_tag]).order(:acc_date)  
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

	def add_transactions
		params["transactions"].each do | key, value|
			# byebug
			unless value[:monea_tag].blank?				
				common_attr = value.slice(:monea_tag,:type,:mi_tag)
				months = value.except(:monea_tag,:type,:mi_tag).reject{ |k, v| v.blank? }		
				months.each do |sub_key, sub_value|
					@transaction = @ledger.transactions.build
					@transaction.type = common_attr[:type]
					@transaction.monea_tag = common_attr[:monea_tag]
					@transaction.mi_tag = common_attr[:mi_tag]
					@transaction.amount = sub_value
					@transaction.acc_date = Date.parse(sub_key)
					@transaction.save
				end
			end
		end		
	end

	private

	def set_ledger
		@ledger = CashFlowLedger.find(params[:id])
	end

end