require 'rails_helper'

include ActionController::Caching::Fragments
APP = YAML.load_file('config/application.yml')

describe 'CashFlow reporting Feature', :type => :feature do
    
  before do
    set_auth()
    create_new_cf_and_go_to_show()
  end

  context "page structure" do
    describe "ui setup" do
      it 'should have the input tables', js: true do
        page.should have_css("#revenueTable")
      end
      it 'should have 6 question buttons', js: true do
         expect(within(".grid-items"){all("a")}.count).to eql(6)
      end
      it 'should display loan form', js: true do
         first(".grid-item").click
         sleep 1
         within(".modal-inner"){page.should have_content "Loan Borrowing"}
      end
    end
    describe "on click buttons" do
      it 'should display director salaries form', js: true do
         all(".grid-item")[1].click
         sleep 1
         within(".modal-inner"){page.should have_content "Director Salaries"}
      end
      it 'should display non director salaries form', js: true do
         all(".grid-item")[2].click
         sleep 1
         within(".modal-inner"){page.should have_content "Non-director Salaries"}
      end
      it 'should display stock form', js: true do
         all(".grid-item")[3].click
         sleep 1
         within(".modal-inner"){page.should have_content "Stock purchases"}
      end
      it 'should display fixed asset form', js: true do
         all(".grid-item")[4].click
         sleep 1
         within(".modal-inner"){page.should have_content "Fixed assets"}
      end
      it 'should display customer form', js: true do
         all(".grid-item")[5].click
         sleep 1
         within(".modal-inner"){page.should have_content "Sales revenue owed"}
      end
    end
  end

  # context "editing cf assumptions" do
  #   # describe "starting month" do
  #   #     # it 'should be January', js: true do
  #   #     #     #first(".js-accordion-trigger").click()
  #   #     #     #within((all(".js-accordion-trigger").first).click) { click_link("Starting month") }
  #   #     # end
  #   #     # it 'should change to February' do
  #   #     # end
  #   # end
  # end

  def set_auth
      Rails.cache.clear
      Auth.user_auth
      page.set_rack_session(token: '265378652378682786237846')
      page.set_rack_session(provider: 'googleoauth2')
      @current_user = FactoryGirl.create(:user)
      page.set_rack_session(email: @current_user.email)
      page.set_rack_session(user_id: @current_user.id)
      ApplicationController.any_instance.stub(:verify_token)
      ApplicationController.any_instance.stub(:current_user){ @current_user }
      visit auth_landing_welcome_index_path
  end

  def create_new_cf_and_go_to_show
      within(".slider-action-bar"){find("#new-work-icon")}.click()
      sleep 2
      expect(within(".slider-action-bar"){all("a")}.count).to eql(3)
      first("a[href='/ledgers/new?type=CashFlowLedger']").click()
      expect(page).to have_content "new CashFlow Projection"
      fill_in("ledger_user_tag", :with=> "Test CASHFLOW")
      click_button "Create Ledger"
      sleep 2
      page.should have_content "Ledger successfully added"
  end

end
