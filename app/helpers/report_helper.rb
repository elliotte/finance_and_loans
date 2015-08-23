module ReportHelper

	def yield_amount
		if yield.nil?
			0.00
		else
			yield[:amount].round(2).abs
		end
	end

	def find_data tag, yr
		@data[yr].find { |val| val[:lv_1] == tag }
	end

	def calc_margin numerator, denominator
		num = numerator.to_f
		dum = denominator.to_f
		case
		when num == 0.00
			return '0%'
		end
		case
		when dum == 0.00
			return '-100%'
		end
		margin = num / dum * 100
		return margin.round(0).to_s + '%'
	end
	
	def month_list
		arr = []
	  	  Date::MONTHNAMES.compact.each_with_index{|month, index| arr << [month, index + 1] }
	  	arr
	end

	# ------------------------[]
	# OLD HAVENT LOOKED AT YET
    def cy_lines_with_no_mapping
		@data[:cy].select { |v| v[:lv_2] == "No-Mapping" }
	end

	def py_lines_with_no_mapping
		@data[:py].select { |v| v[:lv_2] == "No-Mapping" }
	end
	#to test
	def display_ifrs(amount)
		if amount == nil
			return 0.00
		elsif amount.class == String
			return 0.00
		else
			bracket_display = '(' + (amount * -1).round(0).to_s + ')'
			normal_display = amount.round(0)
			amount >= 0.00 ? normal_display : bracket_display
		end
	end
	# Input data data object and amount amount_sum
	# Input last amount and all amount
	# Return the sum of each object for pivot table
	# def report_options
	# 	options = ''
	# 	current_user.reports.each do |report|
	# 		options += content_tag(:option, report.title, value: report.id)
	# 	end
	# 	options.html_safe
	# end

	# def google_friends_list
	# 	friends_list = {}
	# 	@google_friends['items'].each do |friend|
	# 		friends_list[friend['displayName']] = friend['id']
	# 	end
 #      friends_list
	# end


end
