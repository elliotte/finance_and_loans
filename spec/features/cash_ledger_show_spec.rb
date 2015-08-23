require 'rails_helper'

feature 'for type cashbook ledger page' do

      # describe "page content" do
      #   before do
      #     setup_user_and_stub_auth
      #     visit ledger_path(@cash_book)
      #   end
      #   it "should have" do
      #     page.should have_content("Your CashLedger")
      #     page.should have_content("Ledger Lodgements")
      #     page.should have_content("Ledger Payments")
      #     page.should have_content("9.99")
      #     page.should have_css('#showBottom')
      #     page.should have_css('#new-transaction')
      #   end
      # end

      # describe " 'ledger/show' button board features" do
      #   before do
      #       setup_user_and_stub_auth
      #       visit ledger_path(@cash_book)
      #       click_link('showBottom')
      #   end
      #   it 'should be able get a new booking form', js: true do
      #      click_link('Booking.new')
      #   end
      #   it 'should be able get a new payment form', js: true do
      #      click_link('Payment.new')
      #   end
      #   it 'should be able get a new lodgement form', js: true do
      #      click_link('Lodgement.new')
      #   end
      #   it 'should be able get a default csv form', js: true do
      #      click_link('DefaultCSV.new')
      #   end
      #   it 'should be direct to tag manager', js: true do
      #      click_link('Tag.manager')
      #   end
      #   it 'should be able direct to all report transactions', js: true do
      #      click_link('Transactions.all')
      #   end
      # end

      # def setup_user_and_stub_auth
      #     @current_user = FactoryGirl.create(:user)
      #     @cash_book = FactoryGirl.create(:cash_ledger)
      #     transaction = FactoryGirl.create(:debit_transaction)
      #     @cash_book.transactions << transaction
      #     @current_user.ledgers << @cash_book
      #     ApplicationController.any_instance.stub(:verify_token)
      #     ApplicationController.any_instance.stub(:current_user){ @current_user }
      # end

end