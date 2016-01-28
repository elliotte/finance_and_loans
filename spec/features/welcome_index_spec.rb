require 'rails_helper'
APP =YAML.load_file('config/application.yml')

feature 'user reports index page' do
    before do
      $authorization = Signet::OAuth2::Client.new(
          :authorization_uri => APP['AUTH_URI'],
          :token_credential_uri => APP['TOKEN_URI'],
          :client_id => APP['CLIENT_ID'],
          :client_secret => APP['CLIENT_SECRET'],
          :redirect_uri => APP['REDIRECT_URIS'],
          :scope => APP['PLUS_LOGIN_SCOPE'])

      $client = Google::APIClient.new(:application_name => 'ProfitBees',
                                  :application_version => '1.0.0')
      $client.authorization.refresh_token= '26537865237868278623787'
      $client.authorization.grant_type= "refresh_token"
       $client.authorization.access_token='265378652378682786237846'
      @current_user = FactoryGirl.create(:user)
      @report = FactoryGirl.create(:report,user_id: @current_user.id)
      page.set_rack_session(token: '265378652378682786237846')
      page.set_rack_session(provider: 'googleoauth2')
      #controller.session[:token] = '265378652378682786237846'
      @current_user.reports << @report
      ApplicationController.any_instance.stub(:verify_token)
      ApplicationController.any_instance.stub(:current_user){ @current_user }
      visit auth_landing_welcome_index_path
    end
    describe "Create Reports & Journals " do
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
          within(".slider-action-bar"){all("a")}.count==2
        end

        it 'should be able to add a new UKGAAP', js: true do
          within(".slider-action-bar"){find("#new-work-icon")}.click()
          sleep 1
          expect(within(".slider-action-bar"){all("a")}.count).to eql(2)
          first("a[href='/reports/new.UKGAAP']").click()
          expect(page).to have_content "new BoardPack"
          fill_in("report_title",:with=> "Test Report")
          click_button "Create Report"
          sleep 2
          page.should have_content "Successfully created Report"
        end

        it 'should be able to add a new IFRS', js: true do
           within(".slider-action-bar"){find("#new-work-icon")}.click()
          sleep 1
          expect(within(".slider-action-bar"){all("a")}.count).to eql(2)
          first("a[href='/reports/new.IFRS']").click()
          expect(page).to have_content "new BoardPack"
          fill_in("report_title",:with=> "Test Report")
          click_button "Create Report"
          sleep 2
          page.should have_content "Successfully created Report"
        end

    it "Create Journal", js: true do
      pending # Not redirecting to report show apge 
      visit reports_path
      page.should have_content "BoardPacks"

      within(".cards") do 
        all(".card").first.click()        
      end

      ["Insights","Notes","Comments"].each do |text|
        page.should have_content text 
      end
      within(".slider-action-bar"){find("#new-work-icon")}.click()
      within(".slider-action-bar"){all("a")}.first.click()
      page.should have_content "New Journal for report IFRS example report"
      fill_in("description",:with=>"Test Description")
      fill_in("report_etb_values_1_amount",:with=>"116")
      click_button("Book Journal")
      page.should have_content "Journal saved successfully. Please reload the page if you require to see the value included in your view."
    end
  end
end
