class CashLedgersController < LedgersController

  before_action :find_ledger

  def show
    unless ledger_owner?
      redirect_to root_path and return if authorized_user.nil?
    end
      @data = {}
      load_ledger_show
  end
  #can shorten below 3 adding into one with params
  def add_to
    render :'cash_ledgers/show_js/add_to'
  end

  def add_payments
    render :'cash_ledgers/show_js/add_payments'
  end

  def add_lodgements
    render :'cash_ledgers/show_js/add_lodgements'
  end

  def manual_filter
    # used for manual filter ONLY in show page so can be day specific
    render :'cash_ledgers/show_js/manual_filter'
  end

  def order_filter
    # USED FOR LEDGER MANAGER
     filter = params[:filter]
     lookUp = {"Amount" => 'amount', "Type" => 'type', "Your tag" => 'mi_tag', "Monea tag" => "monea_tag"}
     @transactions = @ledger.transactions.order(lookUp[filter])
     respond_to do |format|
       format.js { render :'cash_ledgers/trn_order_filter', locals: {trns:  @transactions} }
     end
  end

  def book_single_trn
    result = @ledger.book_single_trn(params[:transaction])
    respond_to do |format|
      format.js { render :'book_single_trn', locals: {result: result} }
    end
  end

  def transactions_for
    #cash SHOW filters (filteBar and manual filter)
    # manual filter does not reload cashBook next 20 functionality
    @data = {}
    load_ledger_transaction_services
    @filtered = true
    respond_to do |format|
      format.js { render :'filtered_transactions', locals: {data: @data} }
    end
  end

  def import_csv
    render :'cash_ledgers/show_js/import_csv'
  end

  def new_google_export
    render :'cash_ledgers/show_js/google_export'
  end

  def ledger_manager
    @transactions = @ledger.transactions.order("acc_date")
  end
  # TB > EXPORT SPEC NOT FINALISED YET
  def trial_balance
    @data = TrialBalance.new(@ledger).return_general_ledger
  end

  def user_csv_import
    result = LedgerImportService.new(@ledger, params[:file], params).book_data
    if result == true
      redirect_to cash_ledger_path(@ledger), notice: "Transactions imported successfully"
    else
      redirect_to cash_ledger_path(@ledger), notice: "Some or all trans did not save"
    end
  end
  #export all trns
  def export_transactons
    @ledger.export_to_csv(date_from_params(params[:from], :date).to_datetime, date_from_params(params[:to], :date).to_datetime)
    @result = google_service.upload_ledger_csv(@ledger.user_tag, session[:token])
    # google result status check done using JS in js.erb file
      respond_to do |f|
        f.js { render :'cash_ledgers/export_ledger_trns' }
        f.any { redirect_to cash_ledger_path(@ledger), notice: "Something went wrong" }
      end
  end
  # EXPORT TRIAL BALANCE
  def export_tb_google
    @ledger.export_tb_to_csv(params["_json"])
    title = "TB " + @ledger.user_tag
    @result = google_service.upload_new_file_csv(title, session[:token])
    controlled_respond_result
  end
  #EXPORT GENERAL LEDGER
  def export_gl_google
    @ledger.export_gl_to_csv(params["_json"])
    @result = google_service.upload_new_file_csv(@ledger.user_tag, session[:token])
    controlled_respond_result
  end

  def next_transactions
    # CASH CYCLE OF TRANSACTIONS SHOW PAGE VIEW ONLY FOR LAST 3 MONTHS, 
    @data = {}
    @transactions = @ledger.transactions_last_3_months.limit(20).offset(params[:offset])
    #set for cashBook-Headers
    @data[:timeline_transactions] = @transactions
  end

  private

    def find_ledger
      @ledger = CashLedger.find(params[:id])
      $form_select_tags = Tag.gaap_user_options
    end

    def load_ledger_show
      @data = LedgersTransactionService.new(@ledger, @data).set_show_page
    end

    def load_ledger_transaction_services
      @data = LedgersTransactionService.new(@ledger, params).load_data
    end

    def controlled_respond_result
      if @result.status == 200
          respond_to do |f|
              f.js { render js: @result.data.alternateLink }
              f.any { redirect_to cash_ledger_path(@ledger), notice: "Something went wrong" }
          end
      else
          respond_to do |f|
              f.js { render js: "ERROR" }
              f.any { redirect_to cash_ledger_path(@ledger), notice: "Something went wrong" }
          end
      end
    end

end
