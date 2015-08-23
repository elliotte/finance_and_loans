class PurchaseLedgersController < LedgersController

  def show
    # ledger_show feature spec failing
    @ledger = current_user.purchase_ledgers.where(id: params[:id]).last
    @data = {}
    load_ledger_show
    render 'ledgers/show'
  end

end
