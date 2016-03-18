require 'rails_helper'
APP =YAML.load_file('config/application.yml')

describe 'user authorized index page', :type => :feature do
    
    before do
      set_auth()
    end
    context "page structure" do
        describe "ui setup" do
            it "returns user to welcome auth landing page" do           
              ["Hives","Bees"].each do |link_content|
                page.should have_link(link_content)
              end
              current_url.should include "welcome/auth_landing"
            end
            it 'should be having new work icon', js: true do
              within(".slider-action-bar"){page.should have_css("#new-work-icon")}
            end
            it 'should be able to get reports options in slider-action-bar', js: true do
              within(".slider-action-bar"){find("#new-work-icon")}.click()
              within(".slider-action-bar"){all("a")}.count==3
            end
        end
    end
    describe "Creating Reports From Auth Landing " do
        it 'adds a new GAAP report', js: true do
          within(".slider-action-bar"){find("#new-work-icon")}.click()
          sleep 1
          expect(within(".slider-action-bar"){all("a")}.count).to eql(3)
          first("a[href='/reports/new.UKGAAP']").click()
          expect(page).to have_content "new BoardPack"
          fill_in("report_title",:with=> "Test Report")
          click_button "Create Report"
          sleep 2
          page.should have_content "Successfully created Report"
        end
        it 'adds a new IFRS report', js: true do
           within(".slider-action-bar"){find("#new-work-icon")}.click()
          sleep 1
          expect(within(".slider-action-bar"){all("a")}.count).to eql(3)
          first("a[href='/reports/new.IFRS']").click()
          expect(page).to have_content "new BoardPack"
          fill_in("report_title",:with=> "Test Report")
          click_button "Create Report"
          sleep 2
          page.should have_content "Successfully created Report"
        end
        it 'adds create a new cashFlow', js: true do
          within(".slider-action-bar"){find("#new-work-icon")}.click()
          sleep 1
          expect(within(".slider-action-bar"){all("a")}.count).to eql(3)
          first("a[href='/ledgers/new?type=CashFlowLedger']").click()
          expect(page).to have_content "new CashFlow Projection"
          fill_in("ledger_user_tag",:with=> "Test CASHFLOW")
          click_button "Create Ledger"
          sleep 2
          page.should have_content "Ledger successfully added"
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

end
