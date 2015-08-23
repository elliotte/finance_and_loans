require 'rails_helper'

RSpec.describe CashLedgersController, :type => :controller do

    before do
      @current_user = FactoryGirl.create(:user)
      @cash_book = FactoryGirl.create(:cash_ledger)
      controller.session[:token] = '265378652378682786237846'
      controller.stub(:current_user).and_return(@current_user)
      @current_user.ledgers << @cash_book
    end
    #xhr added  to spec to make CRSF save due to updates in Rails 4.1+
    describe "GET 'SHOW' page" do
        it "correctly assigns user ledgers as a @ledger" do
            xhr :get, :show, id: @cash_book.id
            test_ledger = @cash_book
            controller_ledger = assigns(:ledger)
            expect(controller_ledger).to eq(test_ledger)
        end
        it "renders correct template" do
            xhr :get, :show, id: @cash_book.id
            expect(response).to render_template(:show)
        end
        it "returns http success" do
            xhr :get, :show, id: @cash_book.id
            expect(response).to be_success
        end
        it 'calls sets an @data instance' do
            xhr :get, :show, id: @cash_book.id
            expect(assigns(:data)).to be_kind_of(Hash)
        end
    end
    #cashLedger show page specs ...
    describe "GET 'add_payments' form" do
        it "correctly assigns user ledgers as a @ledger" do
            xhr :get, :add_payments, id: @cash_book.id, format: 'js'
            test_ledger = @cash_book
            controller_ledger = assigns(:ledger)
            expect(controller_ledger).to eq(test_ledger)
        end
        it "renders correct template" do
            xhr :get, :add_payments, id: @cash_book.id, format: 'js'
            expect(response).to render_template(:add_payments)
        end
        it "returns http success" do
            xhr :get, :add_payments, id: @cash_book.id, format: 'js'
            expect(response).to be_success
        end
    end
    describe "GET 'add_lodgements' form" do
        it "correctly assigns user ledgers as a @ledger" do
            xhr :get, :add_lodgements, id: @cash_book.id, format: 'js'
            test_ledger = @cash_book
            controller_ledger = assigns(:ledger)
            expect(controller_ledger).to eq(test_ledger)
        end
        it "renders correct template" do
            xhr :get, :add_lodgements, id: @cash_book.id, format: 'js'
            expect(response).to render_template(:add_lodgements)
        end

        it "returns http success" do
            xhr :get, :add_lodgements, id: @cash_book.id, format: 'js'
            expect(response).to be_success
        end
    end
    describe "GET 'manual filter' form" do
        it "correctly assigns user ledgers as a @ledger" do
            xhr :get, :manual_filter, id: @cash_book.id, format: 'js'
            test_ledger = @cash_book
            controller_ledger = assigns(:ledger)
            expect(controller_ledger).to eq(test_ledger)
        end
        it "renders correct template" do
            xhr :get, :manual_filter, id: @cash_book.id, format: 'js'
            expect(response).to render_template(:manual_filter)
        end

        it "returns http success" do
            xhr :get, :manual_filter, id: @cash_book.id, format: 'js'
            expect(response).to be_success
        end
    end

    describe 'POST book single transactions no VAT' do
        it 'should add 1 transactions' do
            params = {id: @cash_book.id, format: 'js', "transaction"=>{"mi_tag"=>"asd", "amount"=>"111", "monea_tag"=>"Debtor Receipt", "acc_date"=>"2015-04-08", "type"=>"Credit"}}
            expect {xhr :post, :book_single_trn, params}.to change(@cash_book.transactions, :count).by(1)
        end

        it 'should not add 1 transactions invalid attributes' do
            params = {id: @cash_book.id, format: 'js', "transaction"=>{"mi_tag"=>"asd", "amount"=>"", "monea_tag"=>"Debtor Receipt", "acc_date"=>"2015-04-08", "type"=>"Credit"}}
            expect {xhr :post, :book_single_trn, params}.to change(@cash_book.transactions, :count).by(0)
        end
    end

    describe 'POST book single transactions with VAT' do
        it 'should add 1 transactions including VAT' do
            params = {id: @cash_book.id, format: 'js', "transaction"=>{"mi_tag"=>"asd", "amount"=>"111", "vat"=>"1.20", "monea_tag"=>"Debtor Receipt", "acc_date"=>"2015-04-08", "type"=>"Credit"}}
            xhr :post, :book_single_trn, params
            expect(@cash_book.transactions.last.vat).to eq 1.20
        end
        it 'should set VAT to zero when blank' do
            params = {id: @cash_book.id, format: 'js', "transaction"=>{"mi_tag"=>"asd", "amount"=>"111", "monea_tag"=>"Debtor Receipt", "acc_date"=>"2015-04-08", "type"=>"Debit"}}
            xhr :post, :book_single_trn, params
            expect(@cash_book.transactions.last.vat).to eq 0.00
        end
    end

    describe "GET 'transactions' for this month" do
        it "correctly assigns user ledgers as a @ledger" do
            xhr :get, :transactions_for, id: @cash_book.id, format: 'js', period: 'this_month'
            test_ledger = @cash_book
            controller_ledger = assigns(:ledger)
            expect(controller_ledger).to eq(test_ledger)
        end

        it "renders correct template" do
            xhr :get, :transactions_for, id: @cash_book.id, format: 'js', period: 'this_month'
            expect(response).to render_template(:filtered_transactions)
        end

        it "returns http success" do
            xhr :get, :transactions_for, id: @cash_book.id, format: 'js', period: 'this_month'
            expect(response).to be_success
        end
    end

    describe "GET 'transactions' for last month" do
        it "correctly assigns user ledgers as a @ledger" do
            xhr :get, :transactions_for, id: @cash_book.id, format: 'js', period: 'last_month'
            test_ledger = @cash_book
            controller_ledger = assigns(:ledger)
            expect(controller_ledger).to eq(test_ledger)
        end

        it "renders correct template" do
            xhr :get, :transactions_for, id: @cash_book.id, format: 'js', period: 'last_month'
            expect(response).to render_template(:filtered_transactions)
        end

        it "returns http success" do
            xhr :get, :transactions_for, id: @cash_book.id, format: 'js', period: 'last_month'
            expect(response).to be_success
        end
    end

    describe "GET 'transactions' for manual filter" do
        it "correctly assigns user ledgers as a @ledger" do
            xhr :get, :transactions_for, id: @cash_book.id, format: 'js', from: {"date(1i)"=>"2014", "date(2i)"=>"8", "date(3i)"=>"10"}, to: {"date(1i)"=>"2014", "date(2i)"=>"8", "date(3i)"=>"10"}
            test_ledger = @cash_book
            controller_ledger = assigns(:ledger)
            expect(controller_ledger).to eq(test_ledger)
        end
        it "renders correct template" do
            xhr :get, :transactions_for, id: @cash_book.id, format: 'js', from: {"date(1i)"=>"2014", "date(2i)"=>"8", "date(3i)"=>"10"}, to: {"date(1i)"=>"2014", "date(2i)"=>"8", "date(3i)"=>"10"}
            expect(response).to render_template(:filtered_transactions)
        end

        it "returns http success" do
            xhr :get, :transactions_for, id: @cash_book.id, format: 'js', from: {"date(1i)"=>"2014", "date(2i)"=>"8", "date(3i)"=>"10"}, to: {"date(1i)"=>"2014", "date(2i)"=>"8", "date(3i)"=>"10"}
            expect(response).to be_success
        end
    end

    describe "GET 'transactions' for order filter  " do
        it "correctly assigns user ledgers as a @ledger" do
            xhr :get, :order_filter, id: @cash_book.id, format: 'js'
            test_ledger = @cash_book
            controller_ledger = assigns(:ledger)
            expect(controller_ledger).to eq(test_ledger)
        end
        it "renders correct template" do
            xhr :get, :order_filter, id: @cash_book.id, format: 'js'
            expect(response).to render_template(:trn_order_filter)
        end
        it "returns http success" do
            xhr :get, :order_filter, id: @cash_book.id, format: 'js'
            expect(response).to be_success
        end
        it 'returns 2 transactions in mi tag order' do
            @cash_book.transactions << FactoryGirl.create(:credit_transaction, mi_tag: 'Dost_1', amount: 10.01, acc_date: Date.today)
            @cash_book.transactions << FactoryGirl.create(:debit_transaction, mi_tag: 'Cost_1', amount: 11.01, acc_date: Date.today)
            xhr :get, :order_filter, id: @cash_book.id, format: 'js', filter: "Your tag"
            controller_trns = assigns(:transactions)
            expect(controller_trns.first.mi_tag).to eq 'Cost_1'
        end
        it 'returns 2 transactions in amount order' do
            @cash_book.transactions << FactoryGirl.create(:credit_transaction, mi_tag: 'Dost_1', amount: 10.01, acc_date: Date.today)
            @cash_book.transactions << FactoryGirl.create(:debit_transaction, mi_tag: 'Cost_1', amount: 9.01, acc_date: Date.today)
            xhr :get, :order_filter, id: @cash_book.id, format: 'js', filter: "Amount"
            controller_trns = assigns(:transactions)
            expect(controller_trns.first.amount).to eq 9.01
        end
    end

    describe "GET 'upload form' for importing a CSV" do
        it "correctly assigns user ledger as a @ledger" do
            xhr :get, :import_csv, id: @cash_book.id, format: 'js'
            test_ledger = @cash_book
            controller_ledger = assigns(:ledger)
            expect(controller_ledger).to eq(test_ledger)
        end

        it "renders correct template" do
            xhr :get, :import_csv, id: @cash_book.id, format: 'js'
            expect(response).to render_template(:import_csv)
        end

        it "returns http success" do
            xhr :get, :import_csv, id: @cash_book.id, format: 'js'
            expect(response).to be_success
        end
    end

    describe "GET 'upload form' for exporting to google" do
        it "correctly assigns user ledger as a @ledger" do
            xhr :get, :new_google_export, id: @cash_book.id, format: 'js'
            test_ledger = @cash_book
            controller_ledger = assigns(:ledger)
            expect(controller_ledger).to eq(test_ledger)
        end

        it "renders correct template" do
            xhr :get, :new_google_export, id: @cash_book.id, format: 'js'
            expect(response).to render_template(:google_export)
        end

        it "returns http success" do
            xhr :get, :new_google_export, id: @cash_book.id, format: 'js'
            expect(response).to be_success
        end
    end

    describe "GET ledger manager as http" do
        it "correctly assigns user ledger as a @ledger" do
            xhr :get, :ledger_manager, id: @cash_book.id
            test_ledger = @cash_book
            controller_ledger = assigns(:ledger)
            expect(controller_ledger).to eq(test_ledger)
        end
        it "renders correct template" do
            xhr :get, :ledger_manager, id: @cash_book.id
            expect(response).to render_template(:ledger_manager)
        end
        it "returns http success" do
            xhr :get, :ledger_manager, id: @cash_book.id
            expect(response).to be_success
        end
        it "assigns transactions as @transactions" do
            trn = FactoryGirl.create(:transaction)
            @cash_book.transactions << trn
            xhr :get, :ledger_manager, id: @cash_book.id
            trns = assigns(:transactions)
            expect(trns.first.id).to eq trn.id
        end
    end

    describe "GET trial balance as http" do
        it 'correctly assigns ledger' do
            xhr :get, :trial_balance, id:  @cash_book.id
            test_ledger = @cash_book
            controller_ledger = assigns(:ledger)
            expect(controller_ledger).to eq(test_ledger)
        end
        it 'calls TB service object' do
            TrialBalance.any_instance.should_receive(:return_general_ledger).once
            xhr :get, :trial_balance, id:  @cash_book.id
        end
        it 'assigns data instance as TB' do
            xhr :get, :trial_balance, id:  @cash_book.id
            test_data = assigns(:data)
            expect(test_data).to eq({"Bank account"=>[], "VAT"=>[]})
        end
    end

    describe 'POST export_transactions' do
        before do 
            GoogleService.any_instance.stub(:upload_ledger_csv)
        end
        it 'correctly assings user ledger as @ledger' do
            params = {id: @cash_book.id, "from" => {"date(1i)"=>"2013", "date(2i)"=>"8", "date(3i)"=>"23"}, "to" => {"date(1i)"=>"2014", "date(2i)"=>"8", "date(3i)"=>"23"}}
            xhr :post, :export_transactons, params
            test_ledger = @cash_book
            controller_ledger = assigns(:ledger)
            expect(controller_ledger).to eq(test_ledger)
        end
        it 'should return a from date object' do
            params = {id: @cash_book.id, "from" => {"date(1i)"=>"2013", "date(2i)"=>"8", "date(3i)"=>"23"}, "to" => {"date(1i)"=>"2014", "date(2i)"=>"8", "date(3i)"=>"23"}}
            xhr :post, :export_transactons, params
            expect(controller.date_from_params(params["from"], :date).to_datetime).to be_an_instance_of DateTime
        end
        it 'should return a to date object' do
            params = {id: @cash_book.id, "from" => {"date(1i)"=>"2013", "date(2i)"=>"8", "date(3i)"=>"23"}, "to" => {"date(1i)"=>"2014", "date(2i)"=>"8", "date(3i)"=>"23"}}
            xhr :post, :export_transactons, params
            expect(controller.date_from_params(params["to"], :date).to_datetime).to be_an_instance_of DateTime
        end
        it 'should render JS export transactions template' do
            params = {id: @cash_book.id, format: 'js', "from" => {"date(1i)"=>"2013", "date(2i)"=>"8", "date(3i)"=>"23"}, "to" => {"date(1i)"=>"2014", "date(2i)"=>"8", "date(3i)"=>"23"}}
            xhr :post, :export_transactons, params
            expect(response).to render_template(:export_ledger_trns)
        end
    end

    describe 'POST export TB to google'  do
        it 'correctly assings user ledger as @ledger' do
            GoogleService.any_instance.stub(:upload_new_file_csv)
            params = {id: @cash_book.id, "_json" => {} }
            xhr :post, :export_tb_google, params
            test_ledger = @cash_book
            controller_ledger = assigns(:ledger)
            expect(controller_ledger).to eq(test_ledger)
        end
    end

   

    describe "POST 'user_csv_import' with HTTP" do

      # let(:bank) { Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/test_bank.csv") }
      # let(:default) { Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/test_default.csv") }

      # it 'using user bank csv' do
      #   expect{post :user_csv_import, id: @cash_book.id, bank: "true", file: bank}.to change(Transaction, :count).by(82)
      # end
      # it 'using the default csv format' do
      #   expect{post :user_csv_import, id: @cash_book.id, bank: "not_true", file: default}.to change(Transaction, :count).by(24)
      # end
      # it 'redirects to ledger page after succesful posting' do
      #   post :user_csv_import, id: @cash_book.id, bank: "not_true", file: default
      #   is_expected.to redirect_to(cash_ledger_path(@cash_book))
      # end

    end

end
