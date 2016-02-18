class CashFlowService

	def export_transaction_csv(data)
		#headers can't be static..?
		#should can we send with params to contoller from date selectors in DOM?
		
		headers = ["MiTag","Jan'16","Feb'16","Mar'16","Apr'16","May'16","Jun'16","Jul'16","Aug'16","Sept'16","Oct'16","Nov'16","Dec'16"]

		CSV.open("#{Rails.root}/files/new-file.csv", 'w') do |csv|			
			csv << headers
			data.map(&:mi_tag).uniq.each do | mitag |
				months,sum = get_transaction_data(data,mitag)	
  				csv << [mitag,months,sum].flatten
			end
	    end
	end
end

def get_transaction_data(data,mitag)
	months = [], sum=0
	12.times { months << "" }
	data.each do |row,i|
		if (row.mi_tag == mitag )
			months[ row.acc_date.month - 1 ] = row.amount.to_f
			sum = sum + row.amount.to_f  
		end		  							
	end
	return months, sum
end