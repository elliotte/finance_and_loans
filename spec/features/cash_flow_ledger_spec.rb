require 'rails_helper'

APP =YAML.load_file('config/application.yml')

describe 'CashFlow reporting Feature', :type => :feature do
    
  before do
    set_auth()
    create_new_cf()
  end

  context "page structure" do

    describe "ui setup" do
      it 'should have the inuput tables', js: true do
        page.should have_css("#revenueTable")
      end
    end

  end

  context "editing cf assumptions" do

    describe "starting month" do
        it 'should be January', js: true do
            #first(".js-accordion-trigger").click()
            within((all(".js-accordion-trigger").first).click) { click_link("Starting month") }

        end
        it 'should change to February' do

        end
    end

  end

  def set_auth
      Auth.user_auth
      page.set_rack_session(token: '265378652378682786237846')
      page.set_rack_session(provider: 'googleoauth2')
      @current_user = FactoryGirl.create(:user)
      page.set_rack_session(email: @current_user.email)
      page.set_rack_session(user_id: @current_user.id)
      @report = FactoryGirl.create(:report,user_id: @current_user.id)
      @current_user.reports << @report
      ApplicationController.any_instance.stub(:verify_token)
      ApplicationController.any_instance.stub(:current_user){ @current_user }
      visit auth_landing_welcome_index_path
  end

  def create_new_cf

      within(".slider-action-bar"){find("#new-work-icon")}.click()
      sleep 1
      expect(within(".slider-action-bar"){all("a")}.count).to eql(3)
      first("a[href='/ledgers/new?type=CashFlowLedger']").click()
      expect(page).to have_content "new CashFlow Projection"
      fill_in("ledger_user_tag", :with=> "Test CASHFLOW")
      click_button "Create Ledger"
      sleep 2
      page.should have_content "Ledger successfully added"

  end

end
