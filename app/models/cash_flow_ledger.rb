class CashFlowLedger < Ledger

	after_create :book_template_settings

	def book_template_settings
		self.update(cf_settings: settings.to_json)
	end

	def settings
		cf_settings = {
			format: {
				start_month: list_month_names.first,
			    cf_length: "Full-Year"
			},
			select_options: {
				start_month: list_month_names,
				cf_length: ["Quarter", "Half-Year", "Full-Year"]
			},
			data: {
				revenue: [],
				costs: []
			}
		}
		cf_settings
	end

private 

	def list_month_names
		Date::MONTHNAMES.slice(1,12)
	end

end