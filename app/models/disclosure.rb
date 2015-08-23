class Disclosure < ActiveRecord::Base

  require 'yaml'

  belongs_to :report

  scope :current, ->(report){ where(created_at: report.current_end) }

  def self.global_type_options
    ["GlobalReport", "DirectorReport"]
  end

  def self.global_ifrs_vars

    {
  		:company_name => ["Disclosure", "Company name"],
  		:business_year_end => ["Disclosure", "Year end"],
  		:director_1 => ["Disclosure", "Directors"],
  		:director_2 => ["Disclosure", "Directors"],
  		:director_3 => ["Disclosure", "Directors"],
  		:secretary => ["Disclosure", "Secretary"],
      :registered_office => ["Disclosure", "Registered Office"],
      :auditor => ["Disclosure", "Auditor"],
      :country_residence => ["Disclosure", "Registered in"]
  	}

  end

  def self.ifrs_example_body_txt
    HashWithIndifferentAccess.new(YAML.load_file('./files/ifrs_disclosure_commentary.yml'))
  end

  def self.all_ifrs_dir_rep_tags

  	{
  		:change_of_name => ["DirectorReport", "Change of Name"],
  		:principal_activity => ["DirectorReport", "Principal activity"],
  		:activity_review => ["DirectorReport", "Activity Review"],
  		:parent_co => ["DirectorReport", "Parent Company"],
  		:business_review => ["DirectorReport", "Business Review"],
  		:fin_performance => ["DirectorReport", "Financial Performance"],
  		:post_balance_sheet => ["DirectorReport", "Post balance sheet events"]
  	}

  end

  scope :dirrep, -> {
		where(type: 'DirectorReport')
  }

  #change to global
  scope :disclosure, -> {
		where(type: 'Disclosure')
  }

  scope :active, -> {
    where(active: true)
  }

  scope :notactive, -> {
    where(active: false)
  }

  def self.export_data(data_scope, report)
    data_scope == :all ? send(:all) : send(:current, report)
  end

end

class GlobalReport < Disclosure
end

class DirectorReport < Disclosure
end
