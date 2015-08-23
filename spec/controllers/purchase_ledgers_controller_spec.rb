require 'spec_helper'

describe PurchaseLedgersController do
	 before do
      @current_user = FactoryGirl.create(:user)
      @cash_book = FactoryGirl.create(:cash_ledger)
      @sales_book = FactoryGirl.create(:sales_ledger)
      @purchase_book = FactoryGirl.create(:purchase_ledger)
      controller.session[:token] = '265378652378682786237846'
      controller.stub(:current_user).and_return(@current_user)
      @current_user.ledgers << @cash_book
      @current_user.ledgers << @sales_book
      @current_user.ledgers << @purchase_book
    end
end
