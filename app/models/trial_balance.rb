class TrialBalance

	attr_reader :ledger, :data, :transactions

	def initialize ledger
		@ledger = ledger
		@transactions = []
		@data = {'Bank account' => [], "VAT" => []}
	end
	#HAD TO CHANGE TO ALL AS TO_A RETURNED TWICE TRNS IN TEST ENV (NOT DEV)
	def fetch_all_trns
		@ledger.transactions.find_each do |trn|
			@transactions << trn
		end
	end

	def get_all_t_accounts
		@transactions.map { |t| t.monea_tag }.uniq
	end

	def set_t_account_names
		get_all_t_accounts.each do |account_name|
			@data[account_name] = []
		end
	end

	def generate_double_entry_bookings
		
		$trn_ID_counter = 0
		@transactions.each do |tran|
			$collection = @data[tran.monea_tag]
			#need to add VAT catch here somewhere..

			$trn_type =  tran.type
			case $trn_type

			when "Credit"
			    if tran.vat > 0.01
				   # create vat debits
				   create_non_bank_debits(tran)
				   # book_bank_credit
				   credit_amt = tran.amount.to_f * -1
				   @data["Bank account"] << {id: $trn_ID_counter, date: tran.acc_date.to_s, amount:  credit_amt, description: tran.description, mi_tag: tran.mi_tag }
				   $trn_ID_counter += 1
				else
				   #accounting booking logic
				   credit_amount = tran.amount * -1
				   debit_amount = tran.amount
				   $collection << {id: $trn_ID_counter, date: tran.acc_date.to_s, amount: debit_amount.to_f, description: tran.description, mi_tag: tran.mi_tag }
				   $trn_ID_counter += 1
				   @data["Bank account"] << {id: $trn_ID_counter, date: tran.acc_date.to_s, amount: credit_amount.to_f, description: tran.description, mi_tag: tran.mi_tag }
				   $trn_ID_counter += 1
				end
			when "Debit"
			    #accounting booking logic
			    if tran.vat > 0.01
			    	#create vat credits
			    	create_non_bank_credits(tran)
			    	#book bank debit
			    	debit_amt = tran.amount.to_f.round(2)
			    	@data["Bank account"] << {id: $trn_ID_counter, date: tran.acc_date.to_s, amount: debit_amt, description: tran.description, mi_tag: tran.mi_tag }
				    $trn_ID_counter += 1
			    else
					$collection << {id: $trn_ID_counter, date: tran.acc_date.to_s, amount: (tran.amount * -1).to_f, description: tran.description, mi_tag: tran.mi_tag }
					$trn_ID_counter += 1
					@data["Bank account"] << {id: $trn_ID_counter, date: tran.acc_date.to_s, amount: tran.amount.to_f, description: tran.description, mi_tag: tran.mi_tag }
					$trn_ID_counter += 1
			    end
			else
			    #ERROR COLLECT INPUT
			end
		end
	end

	def return_general_ledger
		fetch_all_trns
		set_t_account_names
		generate_double_entry_bookings
		return @data
	end

	def create_non_bank_debits trn
		amt_vat = trn.vat.to_f
		amt_less_vat = (trn.amount.to_f - amt_vat).round(2)
		date = trn.acc_date
		@data["VAT"] << {id: $trn_ID_counter, date: date , amount: amt_vat, description: trn.description, mi_tag: trn.mi_tag }
		$trn_ID_counter += 1
		$collection << {id: $trn_ID_counter, date: date, amount: amt_less_vat, description: trn.description, mi_tag: trn.mi_tag }
		$trn_ID_counter += 1
	end

	def create_non_bank_credits trn
		amt_vat = trn.vat.to_f * -1
		amt_less_vat = ( (trn.amount.to_f * -1) - amt_vat).round(2)
		date = trn.acc_date
		@data["VAT"] << {id: $trn_ID_counter, date: date , amount: amt_vat, description: trn.description, mi_tag: trn.mi_tag }
		$trn_ID_counter += 1
		$collection << {id: $trn_ID_counter, date: date, amount: amt_less_vat, description: trn.description, mi_tag: trn.mi_tag }
		$trn_ID_counter += 1
	end


end

