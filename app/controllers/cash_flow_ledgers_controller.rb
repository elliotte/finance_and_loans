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

	def add_transactions
		#@ledger.add_user_inputs(params)
		#ADD in VAT
		params["transactions"].each do | key, value|
			#PB/MONEA TAG NOT RENDERED IN VIEW FOR SAVED
			#USED AS A FILTER to DETERMINE UPDATE OR ADD
			unless value[:monea_tag].blank?	
				next if value[:mi_tag].blank?			
				common_attr = value.slice(:monea_tag, :type, :mi_tag)
				months = value.except(:monea_tag, :type, :mi_tag) #.reject{ |k, v| v.blank? }		
				months.each do |sub_key, sub_value|
					@transaction = @ledger.transactions.build
					@transaction.type = common_attr[:type]
					@transaction.monea_tag = common_attr[:monea_tag]
					@transaction.mi_tag = common_attr[:mi_tag]
					@transaction.amount = sub_value.to_f 
					@transaction.acc_date = Date.parse(sub_key)
					@transaction.save
				end
			else
				#PB/MONEA TAG NOT RENDERED IN VIEW FOR SAVED
				#USED AS A FILTER to DETERMINE UPDATE OR ADD
				update_transactions(value)
			end
		end	
	end

	def export_transactions_to_csv
		CSV.open("#{Rails.root}/files/new-file.csv", 'w') do |csv|
		    headers = ["acc_date", "Your tag", "ProfitBees Tag", "vat", "amount", "AccountingType" ]
			csv << headers
			params[:tags].each do |reporting_tag|
				@transactions = @ledger.transactions.where(monea_tag: reporting_tag)
				@transactions.each do |trn|
				  amt = trn.amount.to_i	
				  next if amt < 1
			
				  csv << trn.attributes.values_at("acc_date", "mi_tag", "monea_tag", "vat", "amount", "type" )
				end
			end			
	    end
		export_google_sheet_and_return_link unless current_user.uid.include? "Office365"				
		#link handling in route js.erb file
	end

private

	def set_ledger
		@ledger = CashFlowLedger.find(params[:id])
	end

	def update_transactions(transaction_value)
		trans_key = transaction_value.except(:monea_tag,:type,:mi_tag)
		trans_key.each do |key, value|
			transaction = Transaction.where("mi_tag=? and acc_date=?", transaction_value[:mi_tag], Date.parse(key) ).first 
			transaction.update( amount: value )
		end				
	end

	def group_transactions_and_return(tag)
		@ledger.transactions.where(:monea_tag=>tag).group([:id, :mi_tag]).order(:acc_date)		
	end

	def export_google_sheet_and_return_link
		@result = google_service.upload_new_file_csv("ProfitBees Export:  " + Date.today.to_s, session[:token] )
    	@link = @result.data.alternateLink rescue "Something went wrong"
	end

end


