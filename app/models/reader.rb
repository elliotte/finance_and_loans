class Reader < ActiveRecord::Base
  belongs_to :report

  def self.shared_reports(user_id)
  	where(:uid=>user_id)
  end
end
