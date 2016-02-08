class ReportsController < ApplicationController
    
    respond_to :html, :js
    before_action :set_report, only: [:view_etb, :new_journal, :save_journal, :share, :get_notes, :get_comments, :get_breakdown_values]
    before_action :initialize_report, only: [:show,:show_dashboard,:export_dash,:export_dash_o365,:export_form,:to_google_export,:delete_value,:report_manager,:show_readers]
    
    def index
      @reports = current_user.reports
    end
    #CRUD routes
    def new
      @report = current_user.reports.new 
    end

    def create
      @report = current_user.reports.build(report_params)
      if @report.save
        flash[:notice] = "Successfully created Report"
        redirect_to report_path(@report)
      else
        flash[:notice] = "Something went wrong"
        render 'new'
      end
    end

    def edit
       @report = current_user.reports.find(params[:id])
    end

    def update
      @report = current_user.reports.find(params[:id])
      @report.update(report_params)
      if @report.save
          render :'reports/update', locals: {report: @report}
      else
        render 'edit'
      end
    end

    def show
      set_app_reporting_tags
      unless report_owner?
        redirect_to root_path and return if authorized_user.nil?
      end
      @data = ReportsValueService.new(@report).load_show_page
    end

    def destroy
      @report = current_user.reports.find(params[:id])
      @report.destroy!
      redirect_to reports_path
    end
    #END OF CRUD ROUTES
    #FEATURE ROUTES
    def report_manager
      @values = @report.values.order("repdate")
    end

    def show_dashboard
      set_app_reporting_tags
      @data = ReportsDashService.new(@report).load_data
    end
    # SHARE WITH MONEA USER
    def share
      #checks set_report finds owner, otherwise not owner and cant share
      msg = "ERROR only the report owner can share"
      unless @report.blank?

       found_user = User.where(["uid=? OR id=?",params[:userID].to_s,Integer(params[:userID])]).first
       
        if found_user.nil? 
           msg = "USER NOT FOUND" 
        else
          new_reader = @report.readers.create(uid: found_user.id) unless found_user.nil?       
          error = true if new_reader.nil?
          #add (if error) test
          msg = found_user.email
        end
      end
      render js: msg
    end
    #END OF FEATURE REOUTS
    #EXPORT to GOOGLE routes
    def export_dash     
      @report.export_dash_to_csv(params["_json"])
        
        @result = google_service.upload_new_file_csv(@report.title, session[:token])
        if @result.status == 200
          respond_to do |f|
              f.any { render js: @result.data.alternateLink }
          end
        else
          respond_to do |f|
              f.js { render js: "ERROR" }
              f.any { redirect_to report_path(@report), notice: "Something went wrong" }
          end
        end
    end
    #FORM GET
    def export_form; end
    #API endpoint route
    def to_google_export
      #not tested yet      
      export_request = params[:report][:export]
      current_range = Date.new(params[:report]['current_end(1i)'].to_i, params[:report]['current_end(2i)'].to_i)
      comparative_range = Date.new(params[:report]['comparative_end(1i)'].to_i, params[:report]['comparative_end(2i)'].to_i)
      @report.spreadsheet_export(export_request, current_range, comparative_range)
      unless current_user.uid.include? "Office365"
          @result = google_service.upload_new_file_csv(@report.title, session[:token])
          if @result.status == 200
            respond_to do |f|
              f.js
              f.any { redirect_to report_path(@report), notice: "Something went wrong" }
            end
          else
            respond_to do |f|
              f.js
              f.any { redirect_to report_path(@report), notice: "Something went wrong" }
            end
          end
      end
    end
    #windows 0365 export routes
    def export_dash_o365
      @report.export_dash_to_csv(JSON.parse(params["csv"]))
      respond_to do |f|
        f.js
        #f.any { redirect_to report_path(@report), notice: "Something went wrong" }
      end
    end
    # download as csv file
    def download_data_as_csv_file
      send_file "#{Rails.root}/files/new-file.csv", :type=>"application/csv", :x_sendfile=>true
    end
    #END OF EXPORT ROUTES
    #ADDING nested model routes
    def add_value
      @report = current_user.reports.find(params[:id])
      @value = @report.values.build(value_params)
      if @value.mitag == ""
        @value.mitag = 'No-Mapping'
      end
      if @value.description == ""
        @value.description = 'No-description'
      end
      @value.save
    end
    # USED BY REPORT MANAGER
    def update_value
      @report = current_user.reports.find(params[:id])
      @value = @report.values.find(params[:report][:value_id])
      @value.update_attributes(update_value_params)
    end
    #GET form
    def import_csv
      @report = current_user.reports.find(params[:id])
      render :'reports/show_js/import_csv'
    end
    #POST to DB
    def user_csv_import
      begin
        @report = current_user.reports.find(params[:id])
        if params[:file].blank?
          redirect_to report_path(@report), notice: 'No file attached'
        else
          @report.parse_csv_and_book(params[:file])
          redirect_to report_path(@report), notice: "Values imported"
        end
      rescue
        redirect_to report_path(@report), notice: "error while uploading import"
      end
    end
    #Form GET
    def new_journal; end
    #POST
    def save_journal
      if params['report'].blank?
        @error = 'Please add atleast one value'
      else
        @report.book_journal(journal_params['etb_values'], params[:description])
      end
    end
    #END OF ADDING routes
    #OTHER routes
    # FOR LANDING DISPLAY
    def last_user_reports
      @reports = current_user.reports.last_four
      render :'last_user_reports', locals: {reports: @reports}
    end
    # HANDLE BAR FETCH ROUTES FOR DISPLAY MODALS
    def get_notes
      render json: @report.notes[1..-1]
    end

    def get_comments
      render json: @report.comments[1..-1]
    end

    def get_breakdown_values
      period = params[:period] || 'current'
      if params[:summary]
        @data = []
         Tag.gaap_fin_stat_tags[params[:summary].to_sym].each do |tag| 
            _data = @report.get_values_for(@report.send("#{period}_end".to_sym)).where(ifrstag: tag)
            @data << _data
        end
        @data
      else
        @data = @report.get_values_for(@report.send("#{period}_end".to_sym)).where(ifrstag: params[:ifrstag])
      end
      #why puts here?
      puts @data
    end

    def autocomplete_friends_list
        term = (params[:q].blank?)? current_user.email.split("@").last : params[:q]
        users_list = User.where("email!= ? AND email like ?", current_user.email,"%#{term.strip}%").uniq    
        render json: users_list.collect{|user| {id:set_user(user),displayName: user.email,image: "/assets/pb-logo.png"}}
    end

    def autocomplete_google_list
      friends = (params[:q].blank?)? fetch_friends_list : search_friends_list
      render json: friends.collect{|user| {id:user.id,displayName: user.displayName,image: user.image.url}}       
    end

    def delete_value
      @value = @report.values.find(params[:value_id])
      @value.destroy!
    end

    def show_readers
      user =[]
      # Need to add a filter for Google User UID.. as number fires....
      # { Couldn't find User with an out of range value for 'id' }
      # This is working for Google User .. which I don't understand really..
      # how are we finding a User by id using a google.uid?
      @report.readers.each{|reader| user << User.find(reader.uid)}
      @readers = user.collect{|user| {id:user.id,name: user.email,image: "/assets/pb-logo.png"}}
    end

  private
    # BEING USED
    def report_owner?
      User.find(@report.user_id).email == session[:email]
    end

    def authorized_user
        @report.readers.find_by(uid: current_user.id)
    end

    def set_report
      #to change for shared      
      @report = current_user.reports.where(id: params[:id]).last 
    end
    # sets VIEW tags to iterate over 
    # not true actually... not used in financials
    # show page forms for input data
    #managers must be same too
    def set_app_reporting_tags
        if @report.format == "UKGAAP"
          $form_select_tags = Tag.gaap_user_options
        else
          $form_select_tags = Tag.ifrs_user_select_options
        end
    end

    def report_params
      params.require(:report).permit! unless params[:report].blank?
    end

    def update_value_params
      case @value.type
        when "TbValue" then params.require(:tb_value).permit(:ifrstag, :mitag) unless params[:tb_value].blank?
        when "EtbValue" then params.require(:etb_value).permit(:ifrstag, :mitag) unless params[:etb_value].blank?
      end
    end

    def journal_params
      params.require('report').permit!
    end

    def value_params
      params.require(:value).permit(:mitag, :amount, :repdate, :ifrstag, :description)
    end

    def fetch_friends_list
      list = Rails.cache.fetch("FRIENDS_LIST"){google_service.execute_friend_list}
      list
    end

    def search_friends_list
      Rails.cache.read("FRIENDS_LIST").select{|friends| friends["displayName"].downcase.match("#{params[:q]}".downcase)}
    end
   
    def set_user(user)
      (user.uid.include? "Office365")? user.id : user.uid
    end

    def initialize_report
      @report = Report.find(params[:id]) 
    end
end


