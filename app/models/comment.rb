class Comment < ActiveRecord::Base
  belongs_to :report

  before_save :set_repdate

  scope :current, ->(report){ where(repdate: report.current_end) }

  def set_repdate
    self.repdate = report.current_end
  end

  def self.export_data(data_scope, report)
    data_scope == :all ? send(:all) : send(:current, report)
  end

end
