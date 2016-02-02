class NotesController < ApplicationController

  before_action :find_report, only: [:new, :create, :manager, :destroy, :edit, :update, :export_all, :export_current,:get_notes]

  def new
    @note =  @report.notes.build(subject: params[:subject])
  end

  def create
    @note = @report.notes.create(note_params)
    if @note.filelink.blank?
        @result = nil
    else
        @google_service ||= GoogleService.new($client, $authorization)
        @result = @note.copy_file_if_google_link(@google_service)
    end
    Cache.write("Notes"){@report.notes}
  end

  def edit
    @note = @report.notes.find(params[:id])
  end

  def update
    @note = @report.notes.find(params[:id])
    @note.update_attributes(note_params)
  end

  def destroy
    @note = Note.find(params[:id])
    @note.destroy
  end

  def manager
    @notes = @report.notes
  end

  def export_current
    @report.spreadsheet_export('Notes', '', '', :current )
    @result = google_service.upload_new_file_csv(@report.title, session[:token])
    link = @result.data.alternateLink
    redirect_to :back, notice: "Data exported. <a href='#{link}' target='_blank'>Click here</a> to view".html_safe
  end

  def export_all
    @report.spreadsheet_export('Notes', '', '', :all)
    @result = google_service.upload_new_file_csv(@report.title, session[:token])
    link = @result.data.alternateLink
    redirect_to :back, notice: "Data exported. <a href='#{link}' target='_blank'>Click here</a> to view".html_safe
  end

  def get_notes
    notes = Rails.cache.fetch("Notes"){@report.notes}
    @notes = notes.where("subject=?",params[:subject])[1..-1]
  end

private

    def note_params
      params.require(:note).permit(:body, :subject, :commenter, :filelink)
    end

    def find_report
      @report = Report.find(params[:report_id])
    end

    # def find_report_note
    #   @report = Report.find(params[:report_id])
    #   @report.notes.find(params[:id])
    # end

end
