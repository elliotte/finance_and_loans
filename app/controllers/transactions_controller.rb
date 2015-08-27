class TransactionsController < ApplicationController
  
  # MAINLY HANDLES INVOICE (SALESLEDGERS) TRANSACTION FUNCTIONALITY
  def new
    #for creating invoice transactions ONLY
    @transaction = Transaction.new
  end
  def create
    #for creating invoice transactions ONLY
    @transaction = Transaction.create(transaction_params)
  end

  def show
     @transaction = Transaction.find(params[:id])
     respond_to do |f|
        f.js
     end
  end

  def update_transaction_controlled
    # USED BY CASH-LEDGER MANGER AND SALES-LEDGER SHOW PAGE
    @transaction = Transaction.find(params[:transaction][:transaction_id])
    if params[:invoice] == "true"
      [:ledger_id, :mi_tag, :vat, :description, :invoice_file_link].each do |value|
        unless params[:transaction][value].blank?
           @transaction.update(params.require(:transaction).permit(value))
        end
      end
    else
      mi_tag = params[:transaction][:mi_tag]
      vat = params[:transaction][:vat]
      @monea_tag =  params[@transaction.type.downcase.to_sym][:monea_tag]
      @transaction.mi_tag = mi_tag unless mi_tag.blank?
      @transaction.vat = vat unless vat.blank?
      @transaction.monea_tag = @monea_tag unless no_change
      @transaction.save
    end
    render :'transactions/update_mi_tag', locals: {transaction: @transaction}
  end
  #mark INVOICE AS PAID
  def invoice_paid
    byebug
    @transaction = Transaction.find(params[:id])
    @transaction.update(paid: true)
    @transaction.save
    render json: @transaction
  end
  #udpate GOOGLE FILE title
  def update_invoice_file_paid
    $fileID = Transaction.find(params[:id]).invoice_file_link.match(/d\/(.*)?.edit/)[1]
    begin
      @result = google_service.rename_inv_file_paid($fileID, session[:token])
      render json: @result
    rescue
      @result = "ERROR"
      render json:  @result
    end
  end

private

  def transaction_params
    params.require(:transaction).permit(:ledger_id, :amount, :type, :mi_tag, :vat, :acc_date, :description, :monea_tag, :invoice_file_link, :paid)
  end

  def no_change
    return true if @monea_tag == @transaction.monea_tag
    false
  end

end
