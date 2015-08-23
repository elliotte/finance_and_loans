class LedgersController < ApplicationController

  def index
    @cash = current_user.cash_ledgers
    @sales = current_user.sales_ledgers
  end

  def new
    @ledger = current_user.ledgers.new
    respond_to do |format|
      format.js
    end
  end

  def create
    @ledger = current_user.ledgers.create(ledger_params)
      if @ledger.save
        redirect_to ledger_path(@ledger), notice: "Ledger successfully added"
      else
        redirect_to ledgers_path, notice: "Something went wrong, try again"
      end
  end

  def edit
    find_ledger
  end

  def show
    find_ledger
    if @ledger.type == 'PurchaseLedger'
      redirect_to ledgers_path, notice: "Purchase Books not ready"
    else
      redirect_to send("#{@ledger.type.underscore}_path", @ledger)
    end
  end

  def update
    #need to strip out cashLedger ...
    find_ledger
    @ledger.update_attributes(edit_ledger_params)
    respond_to do |format|
      format.js { render :'ledgers/update', locals: {ledger: @ledger} }
    end
  end

  def destroy
    @ledger = current_user.ledgers.find(params[:id])
    @ledger.destroy
    redirect_to ledgers_path, notice: "Successfully deleted ledger"
  end

  def share
    find_ledger
    found_user = User.find_by_uid(params[:userID])
    render js: "USER NOT FOUND" and return if found_user.nil?

      new_viewer = @ledger.viewers.create(uid: found_user.uid)
      error = true if new_viewer.nil?
      #add (if error) test
      render js: found_user.email

  end

  def last_user_ledgers
    #route used for welcome landing
    @ledgers = current_user.ledgers.last_four
    respond_to do |format|
      format.js { render :'last_user_ledgers', locals: {ledgers: @ledgers} }
    end
  end
  # VAT TO BE EXTEND FOR SALES EXPORT HENCE IN LEDGER
  def vat_csv
    find_ledger
    start = date_from_params(params[:from], :date).to_datetime
    _end = date_from_params(params[:to], :date).to_datetime
    @data = VAT.new(@ledger, start, _end).calculate
    #write to csv file ONLY.. exported lataer
    @ledger.write_vat_to_csv(@data)
  end
  def vat_to_google
    find_ledger
    @result = @ledger.upload_vat_csv("VAT return", session[:token]).data
    render json: @result
  end

  private

    def ledger_params
      params.require(:ledger).permit(:user_tag, :type, :opening_balance, :invoice_template_file_link) unless params[:ledger].blank?
    end

    def edit_ledger_params
      if params.include?(:sales_ledger)
        params.require(:sales_ledger).permit(:user_tag, :opening_balance, :drive_folder) unless params[:sales_ledger].blank?
      else
        params.require(:cash_ledger).permit(:user_tag, :opening_balance) unless params[:cash_ledger].blank?
      end
    end

    def find_ledger
      @ledger = Ledger.find(params[:id])
    end

    def ledger_owner?
      User.find(@ledger.user_id).uid == session[:gplus_id]
    end

    def authorized_user
      @ledger.viewers.find_by(uid: session[:gplus_id])
    end
    

end
