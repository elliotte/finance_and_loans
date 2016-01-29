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
      visit reports_path
    end
    describe "Reports/dashboard" do
      it "should go to show dashboard page", js: true do
        page.first(".card-image").click
        # click_link("Financials")
      end
    end
    describe "Notes/new" do
      it "should be able to open a popup", js: true do
        click_link('Notes')
        page.should have_content("Report.note.new")
      end
      it 'should be able to add note for report', js: true do
        fill_in 'note[body]', with: 'Report is Awesome'
        fill_in 'note[filelink]', with: 'google.com'
        click_button('Save Note')
        page.should have_css("input-style")
      end
      it 'should transit to another modal for refresh page', js: true do
        page.should have_content("Successfully added comment:")
        click_link("REFRESH")
        visit reports_path
      end
    end
    describe "Comments/new" do
      it "should be able to open a popup" do
        click_link('Comments')
        page.should have_content("Report.comment.new")
      end
      it 'should be able to add comment for report', js: true do
        fill_in 'comment[body]', with: 'Good report'
        click_button('Save Comment')
        page.should have_css("input-style")
      end
      it 'should transit to another modal for refresh page', js: true do
        page.should have_content("Successfully added comment:")
        click_link("REFRESH")
        visit reports_path
      end
    end
end
