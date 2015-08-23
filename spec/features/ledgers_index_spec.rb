require 'rails_helper'

feature 'user ledgers index page' do
    before do
          @current_user = FactoryGirl.create(:user)
          @cash_book = FactoryGirl.create(:cash_ledger)
          transaction = FactoryGirl.create(:transaction)
          @cash_book.transactions << transaction
          @current_user.ledgers << @cash_book
          ApplicationController.any_instance.stub(:verify_token)
          ApplicationController.any_instance.stub(:current_user){ @current_user }
    end
    describe "ledgers/index" do
        it "returns user ledgers on index page" do
          visit ledgers_path
          page.should have_content("CashLedger")
        end
        it 'should be able to use an ajax form', js: true do
           visit ledgers_path
           page.should_not have_css("input#ledger_user_tag")
           click_link('Ledger.new')
           page.should have_css("input#ledger_user_tag")
        end
        it 'should be able to add a report', js: true do
           visit ledgers_path
           click_link('Ledger.new')
           fill_in 'ledger[user_tag]', with: 'I love Rails!'
           #can't click as http post method test == js?
           #click_button('Create Report')
        end
        it 'should be able to add a new UKGAAP', js: true do
           visit ledgers_path
           click_link('CashLedger.new')
           fill_in 'ledger[user_tag]', with: 'I love Rails!'
        end
    end
end
