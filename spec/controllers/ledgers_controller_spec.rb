require 'rails_helper'

describe LedgersController do

  describe "routes" do
    before do
      @current_user = FactoryGirl.create(:user)
      @cash_book = FactoryGirl.create(:cash_ledger)
      controller.session[:token] = '265378652378682786237846'
      controller.stub(:current_user).and_return(@current_user)
      @current_user.ledgers << @cash_book
    end

    describe "GET 'index'" do
      before do
        get :index
      end
      it "returns http success" do
        expect(response).to be_success
      end
      it 'should render index page' do
        expect(response).to render_template('index')
      end
      it "correctly assigns user ledgers" do
        user_ledgers = @current_user.ledgers
        index_ledgers = assigns(:ledgers)
        expect(index_ledgers).to match_array(user_ledgers)
      end
    end
   
    describe "GET 'new'" do
      before do
        xhr :get, :new, format: 'js'
      end
      it "returns http success" do
        expect(response).to be_success
      end
      it 'should render index new' do
        expect(response).to render_template(:new)
      end
      it 'should asseign the ledger and transaction as new object' do
        expect(assigns(:ledger)).to be_a_new(Ledger)
      end
    end

    describe "POST 'create'" do
      it 'should increase current_user and Transaction count by 1' do
        params = {ledger: FactoryGirl.attributes_for(:ledger)}
        expect { post :create, params}.to change(@current_user.ledgers, :count).by(1)
      end
      it "should redirect to the ledgers index page " do
        post :create, {ledger: FactoryGirl.attributes_for(:ledger)}
        expect(response).to redirect_to(ledger_path(Ledger.last.id))
      end
      it 'should have an opening balance' do
        post :create, {ledger: FactoryGirl.attributes_for(:ledger, opening_balance: 300.00)}
        expect(@current_user.ledgers.last.opening_balance).to eq 300.00
      end
      it 'should have 0.00 if no balance set' do
        post :create, {ledger: FactoryGirl.attributes_for(:ledger)}
        expect(@current_user.ledgers.last.opening_balance).to eq 0.00
      end
    end

    describe "GET edit" do
      before do
         xhr :get, :edit, id: @cash_book.id, format: 'js'
      end
      it 'returns http success' do
        expect(response).to be_success
      end
      it 'should render index page' do
        expect(response).to render_template('edit')
      end
      it 'should assign ledger' do
        test_ledger = @cash_book
        controller_ledger = assigns(:ledger)
        expect(controller_ledger).to eq(test_ledger)
      end
    end

    describe "PUT update" do
      before do
         xhr :put, :update, id: @cash_book.id, cash_ledger: {user_tag: 'Hello', opening_balance: 301.01}, format: 'js'
         expect(@cash_book.user_tag).to eq "Test CashLedger"
         expect(@cash_book.opening_balance).to eq 0.00
      end
      it 'returns http success' do
        expect(response).to be_success
      end
      it 'should render index page' do
        expect(response).to render_template('update')
      end
      it "correctly assigns user ledger" do
        ledger = assigns(:ledger)
        test_book = @cash_book
        expect(test_book).to eq(ledger)
      end
      it "udpates userTag" do
        controller_ledger = assigns(:ledger)
        expect(controller_ledger.user_tag).to eq "Hello"
      end
      it 'updates opening_balance' do
        controller_ledger = assigns(:ledger)
        expect(controller_ledger.opening_balance).to eq 301.01
      end 
    end

    describe "DELETE destroy" do
      it 'should assign ledger' do
        delete :destroy, id: @cash_book.id
        test_ledger = @cash_book
        controller_ledger = assigns(:ledger)
        expect(controller_ledger).to eq(test_ledger)
      end
      it 'should reduce current_user leger count' do
        expect{delete :destroy, id: @cash_book.id}.to change(@current_user.ledgers, :count).by(-1)
      end
    end

    describe "GET 'last_user_ledgers'" do
        before do
           xhr :get, :last_user_ledgers, format: 'js'
        end
        it "renders correct template" do
            expect(response).to render_template(:last_user_ledgers)
        end
        it "returns http success" do
            expect(response).to be_success
        end
        it "correctly assigns user ledgers as last 3" do
            user_ledgers = @current_user.ledgers.last_four
            index_ledgers = assigns(:ledgers)
            expect(index_ledgers).to match_array(user_ledgers)
        end
    end

    describe "PUT 'share' user ledger with viewer" do
        before do
           xhr :put, :share, id: @cash_book.id, userID: 1234, format: 'js'
        end
        it "returns http success" do
            expect(response).to be_success
        end
        it "assigns ledger" do
            user_ledger = @cash_book
            controller_ledger = assigns(:ledger)
            expect(controller_ledger).to eq(user_ledger)
        end
        it 'changes viewers when user is found' do
            expect{xhr :put, :share, id: @cash_book.id, userID: 1234, format: 'js'}.to change(@cash_book.viewers, :count).by(1)
        end
        #how to bolt in renders js text?
        it 'does not change viewers when found' do
          expect{xhr :put, :share, id: @cash_book.id, userID: 14, format: 'js'}.to change(@cash_book.viewers, :count).by(0)
        end
    end

  end
end
