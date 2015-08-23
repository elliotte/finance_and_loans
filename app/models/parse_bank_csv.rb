class ParseBankCSV

	attr_accessor :bank_data, :extracted_data

    def initialize file
    	@file = file
    	@bank_data = []
    	@extracted_data = []
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

	def a_real_row? row
		row.count >= 3 ? true : false
	end 

	def loop_bank_data_and_extract
		@bank_data.each do |row_hash|
			cleansed_transactions = []
			row_hash.each_pair do |k, v|
				cleansed_transactions << v unless not_in_scope?(k)
			end
			@extracted_data << cleansed_transactions
		end
	end

	def cleanse_extracted_data
		@extracted_data.keep_if {|r| a_real_row?(r) }
	end

	def parse_extracted_data
		bank_transactions = []
		@extracted_data.each do |trans|
			bank_transactions << {acc_date: trans[0], description: trans[1], amount: trans[2]}
		end
		return bank_transactions
	end

	def return_data
		#re-factor
		set_bank_data_instance
		loop_bank_data_and_extract
		cleanse_extracted_data
		parse_extracted_data		
	end

	def not_in_scope? key
		if key =~ /alue/
			false
		elsif key =~ /Date/
			false
		elsif key =~ /escription/
			false
		else
			true
		end
	end

end