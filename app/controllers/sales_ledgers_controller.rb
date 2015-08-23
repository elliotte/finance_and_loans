class SalesLedgersController < LedgersController

  before_action :find_ledger

  def show
    unless ledger_owner?
      redirect_to root_path and return if authorized_user.nil?
    end
    @transactions = @ledger.transactions.order(acc_date: :desc)
  end

  def transactions_for 
    # FOR AGED FILTER BUTTONS
    @transactions = @ledger.send(params[:range]).order(acc_date: :desc)
    respond_to do |format|
      format.js { render :'filtered_transactions', locals: {data: @transactions} }
    end
  end

  def to_ss_export
    if params[:sales_ledger][:export] == "all"
      @trns = @ledger.transactions.all
    else
      @trns = @ledger.send(params[:sales_ledger][:export])
    end
    @ledger.contents_to_csv(@trns)
    @result = google_service.upload_new_file_csv("Sales", session[:token])
    #FUCKING UP THE RSPEC TEST!!!
    controlled_respond_result
    #FUCKING UP THE RSPEC TEST!!!
  end

private

  def controlled_respond_result
      if @result.status == 200
          respond_to do |f|
              f.js { render :'show_export' }
              f.any { redirect_to sales_ledger_path(@ledger), notice: "Something went wrong" }
          end
      else
          respond_to do |f|
              f.js { render js: "ERROR" }
              f.any { redirect_to sales_ledger_path(@ledger), notice: "Something went wrong" }
          end
      end
  end

  def find_ledger
    @ledger = SalesLedger.find(params[:id])
  end

  def load_ledger_show;  end

end
