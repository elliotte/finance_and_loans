module NotesHelper
	def get_notes(report,subject)
		report.notes.where("subject=?",subject).first
	end

	def get_comments(report,subject)
		report.comments.where("subject=?",subject).first
	end
end
