class CashFlowLedger < Ledger

	after_create :book_template_assumptions

	def book_template_assumptions
		self.update(cf_settings: base_assumptions, drivers: cf_drivers_data)
	end

	def base_assumptions
		assumptions = {
			format: {
				# to add format: ifrs and gaap
				start_month: list_month_names.first,
			    cf_length: "Full-Year"
			 } 
		}
		assumptions
	end

	def cf_drivers_data
		drivers = {
			loans: {
				# percentage
				rate: 0.01,
				# months
				term: 6,
				amt: 0.00
			},
			vat: {
				cost_rate: 0.2,
				sales_rate: 0.2,
			},
			non_director_wages: {
				ppl: 0,	
				#integar sufficient
				total_cost: 0, 
			},
			director_wages: {
				ppl: 0,	
				#integar sufficient
				total_cost: 0, 
			},
			employer_nics: {
				# percentage
				rate: 0.138
			},
			stock: {
				# cost of
				opening_purchase: 0,
				closing_leftover: 0
			},
			customers: {
				# cost of
				opening_owed: 0,
				closing_owed: 0
			},
			fixed_assets: {
				# cost of
				computers: 0,
				equipment: 0,
				fixtures: 0
			}
		}
		drivers
	end
	# def add_user_inputs params
	# end

private 
	
	def list_month_names
		Date::MONTHNAMES.slice(1,12)
	end

end