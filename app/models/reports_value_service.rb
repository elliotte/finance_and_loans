class ReportsValueService

	attr_accessor :data

	def initialize report
		@report = report
		@data = {}
	end

	def type
		#ugly?
		@report.report_type
	end

	def report_format
		@report.format
	end

	def current_end
		@report.current_end
	end

	def comparative_end
		@report.comparative_end
	end

	def is_stat?
		type == 'Statutory' ? true : false
	end

	def get_cye_values
		@report.get_values_for(current_end, 'TbValue')
	end

	def get_cye_values_etb
		@report.get_values_for(current_end, 'EtbValue')
	end

	def get_pye_values
		@report.get_values_for(comparative_end, 'TbValue')
	end

	def get_pye_values_etb
		@report.get_values_for(comparative_end, 'EtbValue')
	end

	def summarise_by_mitag
		yield.select("mitag, sum(amount)").group(:mitag)
	end

	def summarise_by_description
		yield.select("description, sum(amount)").group(:description)
	end

	def set_show_summary_pivot

		@data[:mitag_summary] = {}
		@data[:mitag_summary][:cp] = {}
		@data[:mitag_summary][:pp] = {}
		cp_summarised = summarise_by_mitag { @data[:c_period_values] }
		py_summarised = summarise_by_mitag { @data[:p_period_values] }

		cp_summarised.each do | line |
			  @data[:mitag_summary][:cp][line.mitag] = line.sum.to_f.round(2)
		end

		py_summarised.each do |line|
			@data[:mitag_summary][:pp][line.mitag] = line.sum.to_f.round(2)
		end

		@data[:description] = {}
		@data[:description][:cp] = {}
		@data[:description][:pp] = {}
		cp_summarised = summarise_by_description { @data[:c_period_values] }
		py_summarised = summarise_by_description { @data[:p_period_values] }
		
		cp_summarised.each do | line |
			  @data[:description][:cp][line.description] = line.sum.to_f.round(2)
		end

		py_summarised.each do |line|
			@data[:description][:pp][line.description] = line.sum.to_f.round(2)
		end
	end

	def set_show_summary_pivot_etb
		
		@data[:mitag_summary] ||= {}
		@data[:mitag_summary][:cp_etb] = {}
		@data[:mitag_summary][:pp_etb] = {}

		cp_summarised = summarise_by_mitag { @data[:c_period_values_etb] }
		py_summarised = summarise_by_mitag { @data[:p_period_values_etb] }

		cp_summarised.each do | line |
			  @data[:mitag_summary][:cp_etb][line.mitag] = line.sum.to_f.round(2)
		end

		py_summarised.each do |line|
			@data[:mitag_summary][:pp_etb][line.mitag] = line.sum.to_f.round(2)
		end

		@data[:description] ||= {}
		@data[:description][:cp_etb] = {}
		@data[:description][:pp_etb] = {}
		cp_summarised = summarise_by_description { @data[:c_period_values_etb] }
		py_summarised = summarise_by_description { @data[:p_period_values_etb] }
		
		cp_summarised.each do | line |
			  @data[:description][:cp_etb][line.description] = line.sum.to_f.round(2)
		end

		py_summarised.each do |line|
			@data[:description][:pp_etb][line.description] = line.sum.to_f.round(2)
		end

	end

	def get_cm_values
		@report.get_values_for(Time.now, 'TbValue')
	end

	def get_pm_values
		@report.get_values_for(Time.now-1.month, 'TbValue')
	end

	def set_monthly_values
		@data[:c_period_values] = get_cm_values
		@data[:p_period_values] = get_pm_values
	end

	def set_stat_values
		@data[:c_period_values] = get_cye_values
		@data[:p_period_values] = get_pye_values
	end

	def set_stat_values_etb
		@data[:c_period_values_etb] = get_cye_values_etb
		@data[:p_period_values_etb] = get_pye_values_etb
	end

	# def extract_etb
	# 	@etb_data = {c_period_values: [], p_period_values: []}
	# 	[:c_period_values, :p_period_values].each do |key|
	# 		@data[key].each do |value|
	# 			if value.class == EtbValue
	# 				@etb_data[key] << value
	# 				@data[key].delete(value)
	# 			end
	# 		end
	# 	end
	# end

	def load_show_page
		if is_stat?
		  set_stat_values
		  #extract etb_values before pivot before setting pivot
		  set_stat_values_etb
		  set_show_summary_pivot
		  set_show_summary_pivot_etb
		else
		  set_monthly_values
		  #i will do monthly
		end
		return @data
	end

end
