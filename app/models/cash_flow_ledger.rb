class CashFlowLedger < Ledger

	after_create :book_template_assumptions

	def book_template_assumptions
		self.update(cf_settings: base_assumptions.to_json)
	end

	def base_assumptions
		assumptions = {
			format: {
				start_month: list_month_names.first,
			    cf_length: "Full-Year"
			},
			select_options: {
				start_month: list_month_names,
				cf_length: ["Quarter", "Half-Year", "Full-Year"]
			},
			data: {
				loans: {
					# percentage
					rate: 0.01,
					# months
					term: 6,
					amt: 0.00,
				}				
			}
		}
		assumptions
	end

private 

	def list_month_names
		Date::MONTHNAMES.slice(1,12)
	end

end