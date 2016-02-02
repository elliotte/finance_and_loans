class CommentsController < ApplicationController

  before_action :set_report

  def new
    @comment = @report.comments.build(subject: params[:subject])
  end

  def create
    @comment = @report.comments.create(comment_params)
    Cache.write("Comments"){@report.comments}
    render js: "ERROR" and return if @comment.nil?
    respond_to do |f|
      f.js
    end
  end

  def edit
    @comment = @report.comments.find(params[:id])
  end

  def update
    @comment = @report.comments.find(params[:id])
    @comment.update_attributes(comment_params)
  end

  def destroy
    @comment = find_report_comment
    @div_id = @comment.id
    render js: "ERROR" and return if @comment.nil?
    @comment.destroy!
  end

  def manager
    @comments = @report.comments
  end

  def export_current
    @report.spreadsheet_export('Comments', '', '', :current )
    @result = google_service.upload_new_file_csv(@report.title, session[:token])
    link = @result.data.alternateLink
    redirect_to :back, notice: "Data exported. <a href='#{link}' target='_blank'>Click here</a> to view".html_safe
  end

  def export_all
    @report.spreadsheet_export('Comments', '', '', :all)
    @result = google_service.upload_new_file_csv(@report.title, session[:token])
    link = @result.data.alternateLink
    redirect_to :back, notice: "Data exported. <a href='#{link}' target='_blank'>Click here</a> to view".html_safe
  end

  def get_comments
    comments=  Rails.cache.fetch("Comments"){@report.comments}
    @comments= comments.where("subject=?",params[:subject])[1..-1]
  end

private

  def comment_params
    params.require(:comment).permit(:body, :subject, :commenter)
  end

  def set_report
    @report = current_user.reports.find(params[:report_id])
  end

  def find_report_comment
    @report.comments.find(params[:id])
  end

end
