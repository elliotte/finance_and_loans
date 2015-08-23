class ReportsDashService

	attr_accessor :data, :mappings
	
	def initialize report
		@report = report
		@data = {cy: "", py: ""}
	end

	def type
		@report.report_type
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
		@report.get_values_for(current_end)
	end

	def get_pye_values
		@report.get_values_for(comparative_end)
	end

	def load_cy
		@data[:cy] = group_cy
	end

	def load_py
		@data[:py] = group_py
	end

  	def load_data
  		load_cy
  		load_py
  		return @data
  	end
  	
	def group_cy
		data = []
		
		vs = @report.summarise_by_ifrs(get_cye_values)
		$mapping_tags = Tag.load_monea_tag_mappings(@report.format)
		
		vs.each do |value|
			tag = value.ifrstag
			amount = value.sum.to_f
			if $mapping_tags.include?(tag)
				data << { lv_1: tag , lv_2: $mapping_tags[tag], amount: amount }
			else
			    data << { lv_1: value.ifrstag , lv_2: 'No-Mapping', amount: amount } 	
			end
		end
		return data
		#and_get_report_mappings(vs)
	end

	def group_py
		data = []
		
		vs = @report.summarise_by_ifrs(get_pye_values)
		$mapping_tags = Tag.load_monea_tag_mappings(@report.format)

		vs.each do |value|
			tag = value.ifrstag
			amount = value.sum.to_f
			if $mapping_tags.include?(tag)
				data << { lv_1: tag , lv_2: $mapping_tags[tag], amount: amount }
			else
			    data << { lv_1: value.ifrstag , lv_2: 'No-Mapping', amount: amount } 	
			end
		end
		return data
		#and_get_report_mappings(vs)
	end
	
end