class ParseValuesCSV 

	attr_accessor :data, :booking, :tags, :format

	def initialize file, report_format = nil
		@file = file
		@data = []
		@booking = []
		@tags = ""
		@format = report_format
	end

	def read_file
		CSV.read(@file, headers: true)
	end

	def fetch_file_values
		read_file.each do |row|
			@data << row.to_hash
		end
	end

	def loop_and_build_booking_hash
		@format ? tag = 'ukgaap' : tag = 'ifrstag'
		@data.each do |value|
			if @tags.include? value[tag]
				@booking << {repdate: value["reporting month"], amount: value["amount"], mitag: value["mi_tag"], description: value["description"], ifrstag: value[tag]}
			else 
				@booking << {repdate: value["reporting month"], amount: value["amount"], mitag: value["mi_tag"], description: value["description"], ifrstag: "No-Mapping"}
			end
		end
	end

	def return_data
		@format ? set_ukgaap_tags : set_ifrstags
		fetch_file_values
		loop_and_build_booking_hash
		return @booking
	end

	def set_ifrstags
		@tags = Tag.ifrs_user_select_options
	end

	def set_ukgaap_tags
		@tags = Tag.report_mgr_gaap_options
	end

end