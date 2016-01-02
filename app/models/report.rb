class Report < ActiveRecord::Base

  	require 'csv'
  	
	validates_presence_of :title

	belongs_to :user
	has_many :values, dependent: :destroy
	has_many :etb_values, dependent: :destroy
	has_many :tb_values, dependent: :destroy
	has_many :disclosures, dependent: :destroy
	has_many :notes, dependent: :destroy
	has_many :comments, dependent: :destroy
	has_many :readers, dependent: :destroy

	accepts_nested_attributes_for :values, :reject_if => lambda { |value| value[:amount].blank? }, allow_destroy: true
	accepts_nested_attributes_for :tb_values, :reject_if => lambda { |value| value[:amount].blank? }, allow_destroy: true
	accepts_nested_attributes_for :etb_values, :reject_if => lambda { |value| value[:amount].blank? }, allow_destroy: true

  	before_create { |report| report.format = 'Monthly' if report.format.blank? }
  	
  	after_create :build_back_end
	after_create :load_base_disclosure_blocks
	
	scope :last_four, -> {order('updated_at desc').first(4)}

	def build_back_end
		#TO strip out after_create
		unless session[:provider].include? "Office365"
      		@google_service ||= GoogleService.new($client, $authorization)
      		folder_url = @google_service.create_user_report_folder(self.title)
      		self.drive_folder = folder_url
      		self.save
      	end
    end

	def get_values_for(month, type = nil)
		if type
			values.where(repdate: (month.beginning_of_month..month.end_of_month), type: type)
		else
			values.where(repdate: (month.beginning_of_month..month.end_of_month))
		end
	end

	def parse_csv_and_book file
	  #valid tag control checks inside parseValues service
	  if format == 'UKGAAP'
	  	values_hash = ParseValuesCSV.new(file.path, 'UKGAAP').return_data
	  else
        values_hash = ParseValuesCSV.new(file.path).return_data
	  end
      book_values(values_hash)
	end
	# SHOULD BE PRIVATE ( AS RELIES ON VALIDATED VIA PARSEVALUESCSV )
	def book_values(v_hash)
	  #to add set TB type restriction on CSV imports
	   v_hash.each do |value|
	      a = values.build(repdate: value[:repdate], amount: value[:amount], description: value[:description], mitag: value[:mitag], ifrstag: value[:ifrstag])
	      a.save
	   end
	end

	def export_dash_to_csv data
		cy = current_end.strftime("%B %Y")
		py = comparative_end.strftime("%B %Y")
		CSV.open("#{Rails.root}/files/new-file.csv", 'w') do |csv|
			headers = ["Reporting Line", cy, py, "FS Mapping"]
			csv << headers
			data.each do |reporting_row|
				csv << reporting_row
			end
	    end
	end

	def spreadsheet_export request, current_range, comparative_range, data_scope = :all
		collection = request.downcase.to_sym
		fetch = get_export_data(collection, current_range, comparative_range, data_scope)
		unless fetch.blank?
			CSV.open("#{Rails.root}/files/new-file.csv", 'w') do |csv|
				fetch.each do |request, data|
					headers = [request.to_s.camelize, "Exported from monea.build"]
					csv << headers
					data.flatten.each do |value|
							row = []
							value.attributes.each do |name, value|
								row << value
							end
							csv << row
					end
				end
	    	end
		end
	end

	def get_export_data(request, current_range, comparative_range, data_scope = :all)
		if request == :all
			{
				values: [ get_values_for(current_range), get_values_for(comparative_range) ],
				disclosures: [disclosures],
				notes: [notes],
				comments: [comments]
			}
		elsif request == :values
			{
				values: [ get_values_for(current_range), get_values_for(comparative_range) ]
			}
		else
			{ request => [self.send(request).send(:export_data, data_scope, self)] }
		end
	end

	def book_journal user_etb_values, description = ''
		jnl_no = calculate_jnl_no
	    user_etb_values.each do |i, value|
	      _value = self.etb_values.create(value)
	      #could move back to move as per H
	      _value.update(description: description, number: jnl_no)
	    end
	end

	def calculate_jnl_no
		current_max = self.etb_values.map(&:number).compact.max
		current_max ? current_max + 1 : 1
	end
	#to change to summarise moneaTag n reName column
	def summarise_by_ifrs filtered_values
	    #used in reportDASHService
    	filtered_values.select("ifrstag, sum(amount)").group(:ifrstag)
  	end

  	def load_base_disclosure_blocks
		global_disclosure_tags = Disclosure.global_ifrs_vars
		example_txt = Disclosure.ifrs_example_body_txt
		text_tags = example_txt[:Global].symbolize_keys

		global_disclosure_tags.each_key do |tag|
			body = text_tags[tag]
			self.disclosures << Disclosure.create(type: global_disclosure_tags[tag][0], title: global_disclosure_tags[tag][1], active: true, body: body)

		end
	end

	# OLD SKYDRIVE INTEGRATION

	# def save_folder_from_drive(data)
	# 	self.skydrive_folder = data.link rescue ""
	# end

end

