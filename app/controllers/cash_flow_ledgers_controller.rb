class CashFlowLedgersController < ApplicationController
	
	before_filter :set_ledger

	def show
	    #change cf settings column to assumptions			
	    @settings = @ledger.cf_settings.symbolize_keys
	    #in group by through association id is mandatory
	    @transactions = @ledger.transactions.group([:id, :mi_tag]).order(:acc_date)	    
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
			else
				update_transactions(value)
			end
		end		
	end

private

	def set_ledger
		@ledger = CashFlowLedger.find(params[:id])
	end

	def update_transactions(transaction_value)
		trans_key = transaction_value.except(:monea_tag,:type,:mi_tag)
		trans_key.each do |key, value|
			transaction = Transaction.where("mi_tag=? and acc_date=?", transaction_value[:mi_tag], Date.parse(key) ).first 
			transaction.update( :amount=> value ) unless transaction.blank?
		end				
	end
end