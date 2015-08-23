class ParseDefaultCSV

	attr_accessor :bank_data, :extracted_data

    def initialize file
    	@file = file
    	@bank_data = []
	end

	def read_file_with_headers
		CSV.read(@file, headers: true)
	end

	def read_file_without_headers
		CSV.read(@file, headers: false)
	end

	def set_bank_data_instance
		read_file_with_headers.each do |row|
			@bank_data << row.to_hash 
		end
	end

	def return_data
		set_bank_data_instance
		return @bank_data	
	end
	# def not_in_scope? key
	# 	if key =~ /alue/
	# 		false
	# 	elsif key =~ /Date/
	# 		false
	# 	elsif key =~ /escription/
	# 		false
	# 	else
	# 		true
	# 	end
	# end

end