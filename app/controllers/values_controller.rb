class ValuesController < ApplicationController

	def new
		@report = Report.find(params[:report_id])
		if request.xhr?
		  render :partial => 'newform'
		else
		  @report
		end
	end

	def create
		@report = Report.find(params[:report_id])
		@value = @report.values.create(value_params)
		if @value.save
			redirect_to report_path(@report)
		else
			render 'new'
		end
	end

	def destroy
  		@value = find_report_value
  		@value.destroy!
  		redirect_to reports_path
  	end

private

  	def value_params
    	params.require(:value).permit(:repdate, :amount, :badline)
  	end

  	def find_report_value
  		@report = Report.find(params[:report_id])
  		@report.values.find(params[:id])
  	end

end
