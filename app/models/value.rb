class Value < ActiveRecord::Base

  belongs_to :report
  before_save :default_values
  validates_presence_of :repdate
  
  scope :tbvalues, ->() {where("LOWER(type) = LOWER(?)", 'TbValue') }
  scope :etbvalues, ->() {where("LOWER(type) = LOWER(?)", 'EtbValue') }
  #scope :seach, -> (month, year) { where("DATE_PART('month', values.repdate) = ? AND DATE_PART('year', values.repdate) = ?", month, year) }
  #can take out below since use values_for?
  scope :by_month, -> (month) { where("DATE_PART('month', values.repdate) = ?", month) }
  scope :by_year, -> (year) { where("DATE_PART('year', values.repdate) = ?", year) }

  def default_values
    self.ifrstag ||= 'No-Mapping'
    self.description ||= 'No description'
    if mitag === nil || mitag === ""
      self.mitag = "No-tag set"
    end
  end	

end
