require 'rails_helper'

RSpec.describe SalesLedgersController, :type => :controller do

    before do
      SalesLedger.any_instance.stub(:build_back_end).and_return(true)
      Transaction.any_instance.stub(:create_drive_file).and_return(true)
      controller.session[:token] = '265378652378682786237846'
      @current_user = FactoryGirl.create(:user)
      @sales_book = FactoryGirl.create(:sales_ledger)
      @current_user.ledgers << @sales_book
    end
    #xhr added  to spec to make CRSF save due to updates in Rails 4.1+
    describe "GET 'SHOW' page" do
      it "correctly assigns user ledgers as a @ledger" do
          xhr :get, :show, id: @sales_book.id
          test_ledger = @sales_book
          controller_ledger = assigns(:ledger)
          expect(controller_ledger).to eq(test_ledger)
      end
    end

    describe "GET transactions_for" do
      before do 
        @sales_book.transactions << FactoryGirl.create(:transaction, acc_date: Time.now, paid: false)
        @sales_book.transactions << FactoryGirl.create(:transaction, acc_date: Time.now-1.month, paid: false)
      end
      it 'can filter a range of transactions by paid' do
        xhr :get, :transactions_for, id: @sales_book.id, range: "paid"
        controller_trns = assigns(:transactions)
        expect( controller_trns ).to eq ( @sales_book.paid )
      end
      it 'can filter a range of transactions by not paid' do
        xhr :get, :transactions_for, id: @sales_book.id, range: "not_paid"
        controller_trns = assigns(:transactions)
        expect( controller_trns ).to eq ( @sales_book.not_paid )
      end
      it 'can filter a range of transactions by current month' do
        xhr :get, :transactions_for, id: @sales_book.id, range: "transactions_current_month"
        controller_trns = assigns(:transactions)
        expect( controller_trns ).to eq ( @sales_book.transactions_current_month )
      end
      it 'can filter a range of transactions by prior month' do
        xhr :get, :transactions_for, id: @sales_book.id, range: "transactions_prior_month"
        controller_trns = assigns(:transactions)
        expect( controller_trns ).to eq ( @sales_book.transactions_prior_month )
      end
      it 'can filter a range of transactions by aged' do
      end
    end

    describe 'POST to SS GOOGLE export'  do
        it 'calls..' do
            # SalesLedger.any_instance.stub(:contents_to_csv)
            # GoogleService.any_instance.should_receive(:upload_new_file_csv).and_return(@result = 200)
            # # controller.stub(:controlled_respond_result).and_return(true)
            # params = {id: @sales_book.id, sales_ledger: {export: "transactions_current_month"}, format: 'js'}
            # xhr :post, :to_ss_export, params
            # expect(@result).to eq 200
        end
    end

end






