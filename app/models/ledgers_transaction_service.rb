class LedgersTransactionService

	attr_accessor :data

	def initialize ledger, params
		@ledger = ledger
		@params = params
		@data = {}
	end

	def period_this_month?
		@params['period'] == 'this_month' ? true : false
	end

	def period_prior_month?
		@params['period'] == 'last_month' ? true : false
	end

	def period_manual?
		@params['period'] == 'manual' ? true : false
	end

	def all_cm_trans
		@ledger.transactions_current_month
	end

	def all_pm_trans
		@ledger.transactions_prior_month
	end

	def last_qtr
		@ledger.transactions_last_3_months
	end

	def set_qtr_transactions
		@data[:timeline_transactions] = last_qtr
		@data[:lodgements] = @ledger.summarise(last_qtr.debit)
		@data[:payments] = @ledger.summarise(last_qtr.credit)
		calc_headlines
	end

	def set_current_month_transactions
		#to change to if ledger.type == cash then use summarise_payments
		#to strip out summarise..
		@data[:timeline_transactions] = all_cm_trans
		@data[:lodgements] = @ledger.summarise(all_cm_trans.debit)
		@data[:payments] = @ledger.summarise(all_cm_trans.credit)
		calc_headlines
	end

	def set_prior_month_transactions
		@data[:timeline_transactions] = all_pm_trans
		@data[:lodgements] = @ledger.summarise(all_pm_trans.debit)
		@data[:payments] = @ledger.summarise(all_pm_trans.credit)
		calc_headlines
	end

	def filtered_transactions 
		if @params['type'] == "showFilter"
			#showPage filter bourbon uses this
			year = @params.key('year').to_i

			from_month = Date::MONTHNAMES.index(@params.key('from'))
			to_month = Date::MONTHNAMES.index(@params.key('to'))
			
			from_filter = Date.new(year, from_month, 1)
			to_filter = Date.new(year, to_month, 1).end_of_month
			@ledger.transactions.for_date(from_filter, to_filter)
		else
		  #manual filter uses this
		  #to put into service filter module as per article bloated etc?
		  start = date_from_params(@params["from"], :date).to_datetime
		  _end = date_from_params(@params["to"], :date).to_datetime
		  @ledger.transactions.for_date(start, _end)
		end
	end

	def set_manual_transactions
		@data[:timeline_transactions] = filtered_transactions
		@data[:lodgements] = @ledger.summarise(filtered_transactions.debit)
		@data[:payments] = @ledger.summarise(filtered_transactions.credit)
		calc_headlines
	end

	def set_show_page
		set_qtr_transactions
		return @data
	end

	def load_data	
		if period_this_month?
			set_current_month_transactions
			return @data
		elsif period_prior_month?
			set_prior_month_transactions
			return @data
		elsif period_manual?
			#cud add in filter?
			set_manual_transactions
			return @data
		else
			@data[:lodgements] = {}
      		@data[:payments] = {}
      		return @data
		end
	end

	def calc_headlines
		@data[:headlines] = {
			count: @data[:timeline_transactions].count,
			sum_payments: sum_payments,
			sum_lodgements: sum_lodgements,
			mvmt: calc_mvmt
		}
	end

	def sum_lodgements
		total = 0.00
		@data[:lodgements].each_value do |amount|
			total += amount.to_f
		end
		return total
	end

	def sum_payments
		total = 0.00
		@data[:payments].each_value do |amount|
			total += amount.to_f
		end
		return total
	end

	def calc_mvmt
		sum_lodgements - sum_payments
	end

	def date_from_params(params, key)
      date_parts = params.select { |k,v| k.to_s =~ /\A#{key}\([1-6]{1}i\)/ }.values
      date_parts[0..2].join('-') + ' ' + date_parts[3..-1].join(':')
    end

end