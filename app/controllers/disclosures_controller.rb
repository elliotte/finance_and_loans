class DisclosuresController < ApplicationController

 before_filter :verify_token
 before_action :set_report

  def index
      @disclosures = @report.disclosures
  end

  def new
      @disclosure = @report.disclosures.build
  end

  def create
      @new_disc = @report.disclosures.create(disclosure_params)
      render js: "ERROR PERSIST FAILURE" and return if @new_disc.nil?
  end

  def edit
      @disclosure = @report.disclosures.find(params[:id])
  end

  def destroy
      @disclosure = @report.disclosures.find(params[:id])
      render js: "ERROR" and return if @disclosure.nil?
      @disclosure.destroy
  end

  def update
      #will this work when different types?
      @disclosure = @report.disclosures.find(params[:id])
      @disclosure.update(disclosure_params)
  end

  def manager
    @disclosures = @report.disclosures
  end

  def export_current
    @report.spreadsheet_export('Disclosures', '', '', :current )
    @result = google_service.upload_new_file_csv(@report.title, session[:token])
    link = @result.data.alternateLink
    redirect_to :back, notice: "Data exported. <a href='#{link}' target='_blank'>Click here</a> to view".html_safe
  end

  def export_all
    @report.spreadsheet_export('Disclosures', '', '', :all)
    @result = google_service.upload_new_file_csv(@report.title, session[:token])
    link = @result.data.alternateLink
    redirect_to :back, notice: "Data exported. <a href='#{link}' target='_blank'>Click here</a> to view".html_safe
  end

private

  def set_report
      @report = current_user.reports.find(params[:report_id])
  end

  def disclosure_params
      params.require(:disclosure).permit! unless params[:disclosure].blank?
  end

  # def update_params
  #     case @disclosure.type
  #       when "GlobalReport" then params.require(:global_report).permit! unless params[:global_report].blank?
  #       when "DirectorReport" then params.require(:director_report).permit! unless params[:director_report].blank?
  #     end
  # end

end
