require 'rails_helper'

APP =YAML.load_file('config/application.yml')                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               

feature 'user reports index page' do
    before do
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

    describe "Notes/new" do

      it "returns user to report show page", js: true do           
          visit report_path(@report.id)

          ["Insights","Notes","Comments"].each do |text|
            page.should have_content text 
          end
      end

      it "returns show dashboard page", js: true do 
        visit report_path(@report.id)
        expect(page).to have_content "Insights"
        click_link("Financials")
        expect(page).to have_content "Business Performance"
      end

      it "Add Notes from performance dropdown", js: true do
        visit report_path(@report.id)
        expect(page).to have_content "Insights"
        click_link("Financials")
        expect(page).to have_content "Business Performance"
        first(".dropdown-button").click()
        within(all(".dropdown-menu.dropdown-select").first){page.should have_link "Notes"}
        within(all(".dropdown-menu.dropdown-select").first){click_link("Notes")}
        sleep 2
        within(".modal-inner"){page.should have_content "Report.note.new"}
        fill_in("note_body",:with=> "First Note")
        click_button("Save Note")
        page.should have_content "To display note in page click:"
      end

      it "Add Comments from performance dropdown", js: true do
        visit report_path(@report.id)
        expect(page).to have_content "Insights"
        click_link("Financials")
        expect(page).to have_content "Business Performance"
        first(".dropdown-button").click()
        within(all(".dropdown-menu.dropdown-select").first){page.should have_link "Comments"}
        within(all(".dropdown-menu.dropdown-select").first){click_link("Comments")}
        sleep 2
        within(".modal-inner"){page.should have_content "Report.comment.new"}
        fill_in("comment_body",:with=> "First Comment")
        click_button("Save Comment")
        page.should have_content "To see the changes click:"
      end
    end
end
