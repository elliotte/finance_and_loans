require 'csv'

class Tag
	#IFRS
	# LOAD MASTER MAPPING LIST
	def self.load_master_ifrs_csv
		CSV.open("#{Rails.root}/files/ifrs_master_mapping_list.csv", headers: true)
	end
	#UKGAAP
	# LOAD MASTER MAPPING LIST
	def self.load_master_gaap_csv
		CSV.open("#{Rails.root}/files/gaap_master_mapping_list.csv", headers: true)
	end
	#user IFRS options
	def self.ifrs_user_select_options
		#used in parseValuesCSV too
		result = []
		Tag.load_master_ifrs_csv.each do |r|
			result <<  r[0] 
		end
		result
	end
	#user GAAP options
	def self.gaap_user_options
		#used in parseValuesCSV too
		#Must have NoMapping in it
		result = []
		CSV.read("#{Rails.root}/files/user-select-uk-gaap.csv").each do |tag|
			result <<  tag[0] 
		end
		result
	end
	# FOR DASH SHOW VIEW LOOPING OVER TAGS [2-levelsMapping ]
	def self.ifrs_fin_stat_tags
		#from master file
		tags_to_return = {}
		mappings = []
		Tag.load_master_ifrs_csv.each do |cell|
			mappings << { cell[1] => cell[0] }
		end
		uniq_parent_keys = Tag.extract_unique_keys { mappings } 
		
		uniq_parent_keys.each do |key|
			return_data = mappings.select { |ob| ob.has_key?(key) }.flat_map(&:values)
			tags_to_return[key.downcase.to_sym] = return_data
		end
		tags_to_return
	end
	# FOR DASH SHOW VIEW LOOPING OVER TAGS [2-levelsMapping]
	def self.gaap_fin_stat_tags
		#from master file
		tags_to_return = {}
		mappings = []
		Tag.load_master_gaap_csv.each do |cell|
			mappings << { cell[1] => cell[0] }
		end
		uniq_parent_keys = Tag.extract_unique_keys { mappings } 
		
		uniq_parent_keys.each do |key|
			return_data = mappings.select { |ob| ob.has_key?(key) }.flat_map(&:values)
			tags_to_return[key.downcase.to_sym] = return_data
		end
		tags_to_return
	end
	# USED BY REPORT DASHSERVICE FOR LV 2 MAPPING CALCULATIONS
    def self.load_monea_tag_mappings format
    	result = {}
		if format == "UKGAAP" 
			Tag.load_master_gaap_csv.each do |row|
				result[row[0]] = row[1]
			end
		else
			Tag.load_master_ifrs_csv.each do |row|
				result[row[0]] = row[1]
			end
		end
		result
    end

    def self.report_mgr_gaap_options
    	result = []
		Tag.load_master_gaap_csv.each do |r|
			result <<  r[0] 
		end
		result
    end
      
    def self.report_mgr_ifrs_options
    	result = []
		Tag.load_master_ifrs_csv.each do |r|
			result <<  r[0] 
		end
		result
    end

	# HELPER IFRS FIN STAT	
	def self.extract_unique_keys 
		yield.flat_map(&:keys).uniq
	end
	def self.default_mitag
		"No-miTag"
	end

	def self.default_monea_tag
		"No-Mapping"
	end

end










