class VAT

	attr_accessor :trns, :payments, :receipts, :summary, :vat_return, :headlines

	def initialize ledger, range_start=nil, range_end=nil
		$ledger = ledger
		$start = range_start
		$end = range_end
		$trns = nil
		$payments = ""
		$receipts = ""
		$headlines = {}
		$summary = {
			vat_return: [],
			csv_data: [],
		}
	end

	def trns
		$trns
	end

	def payments
		$payments
	end

	def receipts
		$receipts
	end

	def summary
		$summary
	end

	def headlines
		$headlines
	end

	def ledger_type_cash?
		return true if $ledger.type == "CashLedger"
	    false
	end

	def date_range_valid?
		return true if $start && $end
		false
	end

	def past_quarter_transactions
		$ledger.transactions_last_3_months
	end

	def query_range
		case
		when !$end
			$trns = past_quarter_transactions
		when !$start
			$trns = past_quarter_transactions
		else
		    $trns = $ledger.transactions.for_date($start, $end)
		end
	end

	def bank_credits
		yield.credit
	end

	def bank_debits
		yield.debit
	end

	def set_trns
		query_range
	end

	def filter_payments
		return if !ledger_type_cash?
		$payments = bank_credits {trns}
	end

	def filter_receipts
		return if !ledger_type_cash?
		$receipts = bank_debits {trns}
	end

	def build_data
		set_trns
	  	filter_payments
	  	filter_receipts
	  	set_all_data
	end

	def calculate
		build_data
		set_vat_return
		return $summary
		#to add return $summary
	end

	def set_vat_return
		$summary[:vat_return] = [
          ["VAT due this period on sales and other outputs","Box 1", headlines[:receipts][:vat]],
          ["VAT due in this period on acquisitions from other EC Member States","Box 2", 0],
          ["Total VAT due","Box 3", headlines[:receipts][:vat] - 0 ],
          ["VAT reclaimed in this period on purchases and other inputs (including acquisitions from EC)","Box 4", headlines[:payments][:vat]],
          ["VAT to/from customs","Box 5", headlines[:receipts][:vat] - headlines[:payments][:vat]],
          ["Total value of sales and all other outputs excluding VAT (including supplies to EC)","Box 6", headlines[:receipts][:net]],
          ["Total value of purchases and all other inputs excluding VAT (including acquisitions from EC)","Box 7", headlines[:payments][:net]],
          ["Total value of all supplies of goods, excluding any VAT, to other EC Member States","Box 8", 0],
          ["Total value of all acquisitions of goods, excluding any VAT, from EC Member States","Box 9", 0]
    	]
	end

	def set_all_data
	   $paid_gross = payments.sum(:amount).to_i
	   $paid_vat = payments.sum(:vat).to_i
	   $received_gross = receipts.sum(:amount).to_i
	   $received_vat = receipts.sum(:vat).to_i
	   p_count = payments.count
	   r_count	= receipts.count
	   net_pay = $paid_gross - $paid_vat
	   net_received = $received_gross - $received_vat
	   data = {
	   	payments: {
	   		no_of_trns: p_count,
	   		gross: $paid_gross,
	   		vat: $paid_vat,
	   		net: net_pay,
	   		},
	   	receipts: {
	   		no_of_trns: r_count,
	   		gross: $received_gross,
	   		vat: $received_vat,
	   		net: net_received,
	   		},
	    total: {
	    	no_of_trns: r_count + p_count,
	   		total_net_purchases: net_pay,
	   		vat_paid: $paid_vat,
	   		total_net_sales: net_received,
	   		vat_sales: $received_vat,
	   		vat_amount_due:  $paid_vat - $received_vat,
	    	},
	   }
	   $headlines = data
	   csv_data = {
	   	payments: [
	   		  ["Number of transactions", p_count],
	   		  ["Vat", $paid_vat],
	   		  ["Net", net_pay],
	   		  ["Gross", $paid_gross]	
	   		],
	   	receipts: [
	   		  ["Number of transactions", r_count],
	   		  ["Vat", $received_vat],
	   		  ["Net", net_received],
	   		  ["Gross", $received_gross]
	   		],
	    total: [
	    	["No of trns", r_count + p_count],
	   		["total net purchases", net_pay],
	   		["vat_paid", $paid_vat],
	   		["Total net sales", net_received],
	   		["VAT sales", $received_vat],
	   		["Vat amount due",  $paid_vat - $received_vat],
	    	],
		}
		$summary[:csv_data] = csv_data
	end

end