class Note < ActiveRecord::Base

  belongs_to :report

  scope :substantiation, -> {
    where(type: 'Substantiation')
  }

  scope :reconciliation, -> {
    where(type: 'Reconciliation')
  }

  scope :current, ->(report){ where(repdate: report.current_end) }

  before_save :set_repdate

  def set_repdate
    self.repdate = self.report.current_end
  end

  def self.export_data(data_scope, report)
    data_scope == :all ? send(:all) : send(:current, report)
  end

  def copy_file_if_google_link googleService
    if filelink
      if google_file_link then file_id = google_file_link end
         
       parent_folder_id = self.report.drive_folder.match(/id=([\S]+)&/)[1]
       new_URL = googleService.copy_file(file_id, 'backUp', parent_folder_id, self.subject)
       self.filelink = new_URL
        
    end
  end
 
private

  def google_file_link
    filelink.match(/d\/(.*)?.edit/)[1]
  end

end


class Substantiation < Note

end

class Reconciliation < Note

end
