class LedgerImportService

	attr_accessor :data, :monea_tags, :options

	def initialize ledger, file, options
		@options = options
		@file = file
		@ledger = ledger
		@data = ""
		@monea_tags = []
	end

	def parse_file
		if @options['bank'] == "false"
			@data = ParseDefaultCSV.new(@file.path).return_data
		end
	end

	def load_master_list
		CSV.open("#{Rails.root}/files/user-select-uk-gaap.csv")
	end

	def set_monea_tags
		load_master_list.each do |tag|
			@monea_tags << tag[0]
		end
	end

	def index_null_monea_tags
		index_list = []
		@data.each_index do |index|
			monea_tag = @data[index]["monea_tag"]
			index_list << index unless valid(monea_tag) 
		end
		index_list
	end

	def set_invalid_to_no_mapping
		index_null_monea_tags.each do |transaction_index|
			@data[transaction_index]["monea_tag"] = 'No-Mapping'
		end
	end

	def valid monea_tag
		@monea_tags.include?(monea_tag)
	end

	def ledger_collection
		@ledger.transactions
	end

	def count_trans
		ledger_collection.count
	end

	def book_data
		parse_file
		set_monea_tags
		set_invalid_to_no_mapping
			start_count = count_trans
			data_count = @data.count
				@data.each do |data|
				  vat_key = check_header
			      new_tran = ledger_collection.build(acc_date: data["accounting date"], amount: data["amount"], description: data["description"], mi_tag: data["mi_tag"], monea_tag: data["monea_tag"], vat: data[vat_key] )
			        if new_tran.amount < 0.00
			          new_tran[:type] = 'Credit'
			          new_tran[:amount] = new_tran.amount * -1
			        else
			           new_tran[:type] = 'Debit'
			        end
			        #negative vat not allowed (is an attribute amount)
			        #not needed as done via financial control?
			        # if new_tran.vat < 0.00
			        # 	new_tran[:vat] = new_tran.vat * -1
			        # end
			      new_tran.save
				end
			end_count = count_trans
		return true if start_count + data_count == end_count
		false
	end

	def check_header
		if data.first.include?('vat')
			return 'vat'
		else
			return 'VAT'
		end
	end

end

