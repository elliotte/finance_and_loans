module ReportHelper

	def yield_amount
		if yield.nil?
			0.00
		else
			yield[:amount].to_i rescue 0
		end
	end

	def find_data tag, yr
		@data[yr].find { |val| val[:lv_1] == tag } rescue 0
	end

	def margin_percentage numerator, denominator
		margin = numerator.to_f / denominator.to_f * 100 rescue 0.00
		return number_to_percentage(margin)
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
		return 0.00 if amount.nil?
		if amount < 0.00
			bracket_display = '(' + number_with_delimiter(amount.abs) + ')'
			bracket_display
		else
			number_with_delimiter(amount)
		end
	end

	def report_owner?
		User.find(@report.user_id).email == session[:email]
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
