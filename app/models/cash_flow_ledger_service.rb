class CashFlowLedgerService
	
	def initialize ledger
		@cf_ledger = ledger
		@rev_tags = set_rev_tags
		@cos_tags = set_cos_tags
	end

	def set_rev_tags
		Tag.gaap_fin_stat_tags[:gp_sales]
	end

	def set_cos_tags
		Tag.gaap_fin_stat_tags[:gp_cos]
	end

	def group_trns_by_mi tag
		#in group by through association id is mandatory
		@cf_ledger.transactions.where(:monea_tag=>tag).group([:id, :mi_tag]).order(:acc_date)		
	end

	# def fetch_trns_and_summarise_by tags
	# 	result = []
	# 	tags.each do |tag|
	# 		result << group_trns_by_mi(tag)
	# 	end
	# 	result
	# end

	# def load_rev_trns
	# 	fetch_trns_and_summarise_by @rev_tags
	# end

	# def load_cos_trns
	# 	fetch_trns_and_summarise_by @cos_tags
	# end

	# def export_transaction_csv(data)
	# 	#headers can't be static..?
	# 	#should can we send with params to contoller from date selectors in DOM?
	# 	headers = ["MiTag","Jan'16","Feb'16","Mar'16","Apr'16","May'16","Jun'16","Jul'16","Aug'16","Sept'16","Oct'16","Nov'16","Dec'16"]
	# 	CSV.open("#{Rails.root}/files/new-file.csv", 'w') do |csv|			
	# 		csv << headers
	# 		data.map(&:mi_tag).uniq.each do | mitag |
	# 			months,sum = get_transaction_data(data,mitag)	
 #  				csv << [mitag,months,sum].flatten
	# 		end
	#     end
	# end
end

# def get_transaction_data(data,mitag)
# 	months = [], sum=0
# 	12.times { months << "" }
# 	data.each do |row,i|
# 		if (row.mi_tag == mitag )
# 			months[ row.acc_date.month - 1 ] = row.amount.to_f
# 			sum = sum + row.amount.to_f  
# 		end		  							
# 	end
# 	return months, sum
# end