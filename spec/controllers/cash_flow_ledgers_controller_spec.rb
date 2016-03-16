require 'rails_helper'
APP =YAML.load_file('config/application.yml')

describe CashFlowLedgersController do

  before do
    set_user_auth()
  end
  context "main routes" do
    describe "GET 'show'" do
        before do
          xhr :get, :show, id: @ledger.id
        end
        it "returns http success" do
          expect(response).to be_success
        end
        it 'should render show template' do
          expect(response).to render_template(:show)
        end
        it 'should asseign the ledger and transactions' do
          expect(assigns(:ledger)).to eq(@ledger)
        end
    end
    describe "GET 'fetch_cf_data_input_form'" do
        before do
          xhr :get, :fetch_cf_data_input_form, id: @ledger.id, format: 'js'
        end
        it "returns http success" do
          expect(response).to be_success
        end
        it 'should render right template' do
          expect(response).to render_template(:fetch_cf_data_input_form)
        end
        it 'should assign the ledger' do
          expect(assigns(:ledger)).to eq(@ledger)
        end
        it 'should assign drivers' do
          expect(assigns(:drivers)).to eq(@ledger.drivers)
        end
    end
  end
  describe "adding transactions to CashFlow" do
      context "as all new transactions" do
          before do
            @params = {"vat"=>"true", "transactions"=>{"0"=>{"monea_tag"=>"Sales", "type"=>"Debit", "mi_tag"=>"1 line", "Jan 2016"=>"100", "Feb 2016"=>"200", "Mar 2016"=>"300", "Apr 2016"=>"", "May 2016"=>"", "Jun 2016"=>"", "Jul 2016"=>"", "Aug 2016"=>"", "Sep 2016"=>"", "Oct 2016"=>"", "Nov 2016"=>"", "Dec 2016"=>""}, "1"=>{"monea_tag"=>"Sales", "type"=>"Debit", "mi_tag"=>"2 line", "Jan 2016"=>"", "Feb 2016"=>"", "Mar 2016"=>"", "Apr 2016"=>"", "May 2016"=>"", "Jun 2016"=>"", "Jul 2016"=>"", "Aug 2016"=>"400", "Sep 2016"=>"500", "Oct 2016"=>"600", "Nov 2016"=>"700", "Dec 2016"=>""}, "2"=>{"monea_tag"=>"Sales", "type"=>"Debit", "mi_tag"=>"", "Jan 2016"=>"", "Feb 2016"=>"", "Mar 2016"=>"", "Apr 2016"=>"", "May 2016"=>"", "Jun 2016"=>"", "Jul 2016"=>"", "Aug 2016"=>"", "Sep 2016"=>"", "Oct 2016"=>"", "Nov 2016"=>"", "Dec 2016"=>""}, "3"=>{"monea_tag"=>"Sales", "type"=>"Debit", "mi_tag"=>"", "Jan 2016"=>"", "Feb 2016"=>"", "Mar 2016"=>"", "Apr 2016"=>"", "May 2016"=>"", "Jun 2016"=>"", "Jul 2016"=>"", "Aug 2016"=>"", "Sep 2016"=>"", "Oct 2016"=>"", "Nov 2016"=>"", "Dec 2016"=>""}, "4"=>{"monea_tag"=>"Other sales", "type"=>"Debit", "mi_tag"=>"", "Jan 2016"=>"", "Feb 2016"=>"", "Mar 2016"=>"", "Apr 2016"=>"", "May 2016"=>"", "Jun 2016"=>"", "Jul 2016"=>"", "Aug 2016"=>"", "Sep 2016"=>"", "Oct 2016"=>"", "Nov 2016"=>"", "Dec 2016"=>""}}, "controller"=>"cash_flow_ledgers", "action"=>"add_transactions", "id"=>@ledger.id.to_s}
          end
          it 'response is success' do
            xhr :post, :add_transactions, @params
            expect(response).to be_success
          end
          it 'adds 24 transactions' do
            expect{xhr :post, :add_transactions, @params}.to change(Transaction, :count).by(24)
          end
      end 
  end
  describe "updating transactions in CashFlow" do
      context "with no new transactions in params" do
          before do
            # taken from byebug extract
            @params = {"vat"=>"true", "transactions"=>{"0"=>{"monea_tag"=>"Sales", "type"=>"Debit", "mi_tag"=>"1 line", "Jan 2016"=>"100", "Feb 2016"=>"200", "Mar 2016"=>"300", "Apr 2016"=>"", "May 2016"=>"", "Jun 2016"=>"", "Jul 2016"=>"", "Aug 2016"=>"", "Sep 2016"=>"", "Oct 2016"=>"", "Nov 2016"=>"", "Dec 2016"=>""}, "1"=>{"monea_tag"=>"Sales", "type"=>"Debit", "mi_tag"=>"2 line", "Jan 2016"=>"", "Feb 2016"=>"", "Mar 2016"=>"", "Apr 2016"=>"", "May 2016"=>"", "Jun 2016"=>"", "Jul 2016"=>"", "Aug 2016"=>"400", "Sep 2016"=>"500", "Oct 2016"=>"600", "Nov 2016"=>"700", "Dec 2016"=>""}, "2"=>{"monea_tag"=>"Sales", "type"=>"Debit", "mi_tag"=>"", "Jan 2016"=>"", "Feb 2016"=>"", "Mar 2016"=>"", "Apr 2016"=>"", "May 2016"=>"", "Jun 2016"=>"", "Jul 2016"=>"", "Aug 2016"=>"", "Sep 2016"=>"", "Oct 2016"=>"", "Nov 2016"=>"", "Dec 2016"=>""}, "3"=>{"monea_tag"=>"Sales", "type"=>"Debit", "mi_tag"=>"", "Jan 2016"=>"", "Feb 2016"=>"", "Mar 2016"=>"", "Apr 2016"=>"", "May 2016"=>"", "Jun 2016"=>"", "Jul 2016"=>"", "Aug 2016"=>"", "Sep 2016"=>"", "Oct 2016"=>"", "Nov 2016"=>"", "Dec 2016"=>""}, "4"=>{"monea_tag"=>"Other sales", "type"=>"Debit", "mi_tag"=>"", "Jan 2016"=>"", "Feb 2016"=>"", "Mar 2016"=>"", "Apr 2016"=>"", "May 2016"=>"", "Jun 2016"=>"", "Jul 2016"=>"", "Aug 2016"=>"", "Sep 2016"=>"", "Oct 2016"=>"", "Nov 2016"=>"", "Dec 2016"=>""}}, "controller"=>"cash_flow_ledgers", "action"=>"add_transactions", "id"=>@ledger.id.to_s}
            @edit_params = {"vat"=>"true", "transactions"=>{"0"=>{"mi_tag"=>"1 line", "Jan 2016"=>"100.0", "Feb 2016"=>"300", "Mar 2016"=>"300.0", "Apr 2016"=>"0.0", "May 2016"=>"0.0", "Jun 2016"=>"0.0", "Jul 2016"=>"0.0", "Aug 2016"=>"0.0", "Sep 2016"=>"0.0", "Oct 2016"=>"0.0", "Nov 2016"=>"0.0", "Dec 2016"=>"0.0"}, "1"=>{"mi_tag"=>"2 line", "Jan 2016"=>"0.0", "Feb 2016"=>"0.0", "Mar 2016"=>"0.0", "Apr 2016"=>"0.0", "May 2016"=>"0.0", "Jun 2016"=>"0.0", "Jul 2016"=>"0.0", "Aug 2016"=>"400.0", "Sep 2016"=>"500.0", "Oct 2016"=>"600.0", "Nov 2016"=>"700.0", "Dec 2016"=>"0.0"}, "2"=>{"monea_tag"=>"Sales", "type"=>"Debit", "mi_tag"=>"", "Jan 2016"=>"", "Feb 2016"=>"", "Mar 2016"=>"", "Apr 2016"=>"", "May 2016"=>"", "Jun 2016"=>"", "Jul 2016"=>"", "Aug 2016"=>"", "Sep 2016"=>"", "Oct 2016"=>"", "Nov 2016"=>"", "Dec 2016"=>""}, "3"=>{"monea_tag"=>"Sales", "type"=>"Debit", "mi_tag"=>"", "Jan 2016"=>"", "Feb 2016"=>"", "Mar 2016"=>"", "Apr 2016"=>"", "May 2016"=>"", "Jun 2016"=>"", "Jul 2016"=>"", "Aug 2016"=>"", "Sep 2016"=>"", "Oct 2016"=>"", "Nov 2016"=>"", "Dec 2016"=>""}, "4"=>{"monea_tag"=>"Other sales", "type"=>"Debit", "mi_tag"=>"", "Jan 2016"=>"", "Feb 2016"=>"", "Mar 2016"=>"", "Apr 2016"=>"", "May 2016"=>"", "Jun 2016"=>"", "Jul 2016"=>"", "Aug 2016"=>"", "Sep 2016"=>"", "Oct 2016"=>"", "Nov 2016"=>"", "Dec 2016"=>""}}, "controller"=>"cash_flow_ledgers", "action"=>"add_transactions", "id"=>@ledger.id.to_s}
            # edit made to Feb-16 transaction amount 200 > 300
            xhr :post, :add_transactions, @params
            expect(@ledger.transactions.count).to eq 24
            @transaction = Transaction.where(mi_tag: "1 line", acc_date: Date.parse("Feb 2016") ).first
            expect(@transaction.amount).to eq 200
          end
          it 'should not add transactions' do
            # as no PB/monea tag present in params
            expect {xhr :post, :add_transactions, @edit_params}.to change(Transaction, :count).by(0)
          end
          it 'edits transaction correctly' do
            xhr :post, :add_transactions, @edit_params
            @transaction = Transaction.where(mi_tag: "1 line", acc_date: Date.parse("Feb 2016") ).first
            expect(@transaction.amount).to eq 300
          end
      end
      context "with saved and new trns in params" do
          before do
            # taken from byebug extract
            @params = {"transactions"=>{"0"=>{"monea_tag"=>"Purchases", "type"=>"Credit", "mi_tag"=>"1 saved line", "Jan 2016"=>"100", "Feb 2016"=>"", "Mar 2016"=>"", "Apr 2016"=>"", "May 2016"=>"", "Jun 2016"=>"", "Jul 2016"=>"", "Aug 2016"=>"", "Sep 2016"=>"400", "Oct 2016"=>"400", "Nov 2016"=>"", "Dec 2016"=>""}, "1"=>{"monea_tag"=>"Decrease in stocks", "type"=>"Credit", "mi_tag"=>"", "Jan 2016"=>"", "Feb 2016"=>"", "Mar 2016"=>"", "Apr 2016"=>"", "May 2016"=>"", "Jun 2016"=>"", "Jul 2016"=>"", "Aug 2016"=>"", "Sep 2016"=>"", "Oct 2016"=>"", "Nov 2016"=>"", "Dec 2016"=>""}, "2"=>{"monea_tag"=>"Subcontractor costs", "type"=>"Credit", "mi_tag"=>"", "Jan 2016"=>"", "Feb 2016"=>"", "Mar 2016"=>"", "Apr 2016"=>"", "May 2016"=>"", "Jun 2016"=>"", "Jul 2016"=>"", "Aug 2016"=>"", "Sep 2016"=>"", "Oct 2016"=>"", "Nov 2016"=>"", "Dec 2016"=>""}, "3"=>{"monea_tag"=>"Direct labour", "type"=>"Credit", "mi_tag"=>"", "Jan 2016"=>"", "Feb 2016"=>"", "Mar 2016"=>"", "Apr 2016"=>"", "May 2016"=>"", "Jun 2016"=>"", "Jul 2016"=>"", "Aug 2016"=>"", "Sep 2016"=>"", "Oct 2016"=>"", "Nov 2016"=>"", "Dec 2016"=>""}, "4"=>{"monea_tag"=>"Carriage", "type"=>"Credit", "mi_tag"=>"", "Jan 2016"=>"", "Feb 2016"=>"", "Mar 2016"=>"", "Apr 2016"=>"", "May 2016"=>"", "Jun 2016"=>"", "Jul 2016"=>"", "Aug 2016"=>"", "Sep 2016"=>"", "Oct 2016"=>"", "Nov 2016"=>"", "Dec 2016"=>""}, "5"=>{"monea_tag"=>"Discounts allowed", "type"=>"Credit", "mi_tag"=>"", "Jan 2016"=>"", "Feb 2016"=>"", "Mar 2016"=>"", "Apr 2016"=>"", "May 2016"=>"", "Jun 2016"=>"", "Jul 2016"=>"", "Aug 2016"=>"", "Sep 2016"=>"", "Oct 2016"=>"", "Nov 2016"=>"", "Dec 2016"=>""}, "6"=>{"monea_tag"=>"Commissions payable", "type"=>"Credit", "mi_tag"=>"", "Jan 2016"=>"", "Feb 2016"=>"", "Mar 2016"=>"", "Apr 2016"=>"", "May 2016"=>"", "Jun 2016"=>"", "Jul 2016"=>"", "Aug 2016"=>"", "Sep 2016"=>"", "Oct 2016"=>"", "Nov 2016"=>"", "Dec 2016"=>""}, "7"=>{"monea_tag"=>"Other direct costs", "type"=>"Credit", "mi_tag"=>"", "Jan 2016"=>"", "Feb 2016"=>"", "Mar 2016"=>"", "Apr 2016"=>"", "May 2016"=>"", "Jun 2016"=>"", "Jul 2016"=>"", "Aug 2016"=>"", "Sep 2016"=>"", "Oct 2016"=>"", "Nov 2016"=>"", "Dec 2016"=>""}}, "controller"=>"cash_flow_ledgers", "action"=>"add_transactions", "id"=>@ledger.id.to_s}
            # new line added into params
            @edit_params = {"transactions"=>{"0"=>{"mi_tag"=>"1 saved line", "Jan 2016"=>"100.0", "Feb 2016"=>"0.0", "Mar 2016"=>"0.0", "Apr 2016"=>"0.0", "May 2016"=>"0.0", "Jun 2016"=>"0.0", "Jul 2016"=>"0.0", "Aug 2016"=>"0.0", "Sep 2016"=>"400.0", "Oct 2016"=>"400.0", "Nov 2016"=>"0.0", "Dec 2016"=>"0.0"}, "1"=>{"monea_tag"=>"Purchases", "type"=>"Credit", "mi_tag"=>"newly added line", "Jan 2016"=>"", "Feb 2016"=>"100", "Mar 2016"=>"100", "Apr 2016"=>"", "May 2016"=>"", "Jun 2016"=>"", "Jul 2016"=>"", "Aug 2016"=>"200", "Sep 2016"=>"", "Oct 2016"=>"", "Nov 2016"=>"", "Dec 2016"=>""}, "2"=>{"monea_tag"=>"Decrease in stocks", "type"=>"Credit", "mi_tag"=>"", "Jan 2016"=>"", "Feb 2016"=>"", "Mar 2016"=>"", "Apr 2016"=>"", "May 2016"=>"", "Jun 2016"=>"", "Jul 2016"=>"", "Aug 2016"=>"", "Sep 2016"=>"", "Oct 2016"=>"", "Nov 2016"=>"", "Dec 2016"=>""}, "3"=>{"monea_tag"=>"Subcontractor costs", "type"=>"Credit", "mi_tag"=>"", "Jan 2016"=>"", "Feb 2016"=>"", "Mar 2016"=>"", "Apr 2016"=>"", "May 2016"=>"", "Jun 2016"=>"", "Jul 2016"=>"", "Aug 2016"=>"", "Sep 2016"=>"", "Oct 2016"=>"", "Nov 2016"=>"", "Dec 2016"=>""}, "4"=>{"monea_tag"=>"Direct labour", "type"=>"Credit", "mi_tag"=>"", "Jan 2016"=>"", "Feb 2016"=>"", "Mar 2016"=>"", "Apr 2016"=>"", "May 2016"=>"", "Jun 2016"=>"", "Jul 2016"=>"", "Aug 2016"=>"", "Sep 2016"=>"", "Oct 2016"=>"", "Nov 2016"=>"", "Dec 2016"=>""}, "5"=>{"monea_tag"=>"Carriage", "type"=>"Credit", "mi_tag"=>"", "Jan 2016"=>"", "Feb 2016"=>"", "Mar 2016"=>"", "Apr 2016"=>"", "May 2016"=>"", "Jun 2016"=>"", "Jul 2016"=>"", "Aug 2016"=>"", "Sep 2016"=>"", "Oct 2016"=>"", "Nov 2016"=>"", "Dec 2016"=>""}, "6"=>{"monea_tag"=>"Discounts allowed", "type"=>"Credit", "mi_tag"=>"", "Jan 2016"=>"", "Feb 2016"=>"", "Mar 2016"=>"", "Apr 2016"=>"", "May 2016"=>"", "Jun 2016"=>"", "Jul 2016"=>"", "Aug 2016"=>"", "Sep 2016"=>"", "Oct 2016"=>"", "Nov 2016"=>"", "Dec 2016"=>""}, "7"=>{"monea_tag"=>"Commissions payable", "type"=>"Credit", "mi_tag"=>"", "Jan 2016"=>"", "Feb 2016"=>"", "Mar 2016"=>"", "Apr 2016"=>"", "May 2016"=>"", "Jun 2016"=>"", "Jul 2016"=>"", "Aug 2016"=>"", "Sep 2016"=>"", "Oct 2016"=>"", "Nov 2016"=>"", "Dec 2016"=>""}, "8"=>{"monea_tag"=>"Other direct costs", "type"=>"Credit", "mi_tag"=>"", "Jan 2016"=>"", "Feb 2016"=>"", "Mar 2016"=>"", "Apr 2016"=>"", "May 2016"=>"", "Jun 2016"=>"", "Jul 2016"=>"", "Aug 2016"=>"", "Sep 2016"=>"", "Oct 2016"=>"", "Nov 2016"=>"", "Dec 2016"=>""}}, "controller"=>"cash_flow_ledgers", "action"=>"add_transactions", "id"=>@ledger.id.to_s}
            xhr :post, :add_transactions, @params
            expect(@ledger.transactions.count).to eq 12
          end
          it 'should add new transactions' do
            xhr :post, :add_transactions, @edit_params
            expect(@ledger.transactions.count).to eq 24
          end
      end 
  end

  describe "exporting transactions from Cashflow" do
      before do
            # taken from byebug extract
            #add transactions to export
            @params = {"vat"=>"true", "transactions"=>{"0"=>{"monea_tag"=>"Sales", "type"=>"Debit", "mi_tag"=>"1 line", "Jan 2016"=>"100", "Feb 2016"=>"200", "Mar 2016"=>"300", "Apr 2016"=>"", "May 2016"=>"", "Jun 2016"=>"", "Jul 2016"=>"", "Aug 2016"=>"", "Sep 2016"=>"", "Oct 2016"=>"", "Nov 2016"=>"", "Dec 2016"=>""}, "1"=>{"monea_tag"=>"Sales", "type"=>"Debit", "mi_tag"=>"2 line", "Jan 2016"=>"", "Feb 2016"=>"", "Mar 2016"=>"", "Apr 2016"=>"", "May 2016"=>"", "Jun 2016"=>"", "Jul 2016"=>"", "Aug 2016"=>"400", "Sep 2016"=>"500", "Oct 2016"=>"600", "Nov 2016"=>"700", "Dec 2016"=>""}, "2"=>{"monea_tag"=>"Sales", "type"=>"Debit", "mi_tag"=>"", "Jan 2016"=>"", "Feb 2016"=>"", "Mar 2016"=>"", "Apr 2016"=>"", "May 2016"=>"", "Jun 2016"=>"", "Jul 2016"=>"", "Aug 2016"=>"", "Sep 2016"=>"", "Oct 2016"=>"", "Nov 2016"=>"", "Dec 2016"=>""}, "3"=>{"monea_tag"=>"Sales", "type"=>"Debit", "mi_tag"=>"", "Jan 2016"=>"", "Feb 2016"=>"", "Mar 2016"=>"", "Apr 2016"=>"", "May 2016"=>"", "Jun 2016"=>"", "Jul 2016"=>"", "Aug 2016"=>"", "Sep 2016"=>"", "Oct 2016"=>"", "Nov 2016"=>"", "Dec 2016"=>""}, "4"=>{"monea_tag"=>"Other sales", "type"=>"Debit", "mi_tag"=>"", "Jan 2016"=>"", "Feb 2016"=>"", "Mar 2016"=>"", "Apr 2016"=>"", "May 2016"=>"", "Jun 2016"=>"", "Jul 2016"=>"", "Aug 2016"=>"", "Sep 2016"=>"", "Oct 2016"=>"", "Nov 2016"=>"", "Dec 2016"=>""}}, "controller"=>"cash_flow_ledgers", "action"=>"add_transactions", "id"=>@ledger.id.to_s}
            xhr :post, :add_transactions, @params
            expect(@ledger.transactions.count).to eq 24
            #stub export
            CashFlowLedgersController.any_instance.stub(:export_google_sheet_and_return_link)
            CSV.open("#{Rails.root}/files/new-file.csv", 'w') do |csv|
                csv
            end
            expect(File.read("#{Rails.root}/files/new-file.csv")).to eq ""
      end
      context "for a GOOGLE user" do
        it 'should export transactions to CSV file' do
          $rev_tags = Tag.gaap_fin_stat_tags[:gp_sales]
          @params = {"tags"=> $rev_tags, "id" => @ledger.id.to_s }
          xhr :get, :export_transactions_to_csv, @params
          file = File.read("#{Rails.root}/files/new-file.csv")
          expect(file).to eq "acc_date,Your tag,ProfitBees Tag,vat,amount,AccountingType\n2016-11-01,2 line,Sales,0.0,700.0,Debit\n2016-10-01,2 line,Sales,0.0,600.0,Debit\n2016-09-01,2 line,Sales,0.0,500.0,Debit\n2016-08-01,2 line,Sales,0.0,400.0,Debit\n2016-03-01,1 line,Sales,0.0,300.0,Debit\n2016-02-01,1 line,Sales,0.0,200.0,Debit\n2016-01-01,1 line,Sales,0.0,100.0,Debit\n"
        end
      end
  end

  def set_user_auth
    ApplicationController.any_instance.stub(:verify_token)
    @current_user = FactoryGirl.create(:user)
    controller.session[:token] = '265378652378682786237846'
    controller.session[:uid] = @current_user.uid
    controller.session[:email]= @current_user.email
    controller.stub(:current_user){ @current_user }
    @ledger = FactoryGirl.create(:cash_flow_ledger)
    @current_user.ledgers << @ledger
  end

end