require 'rails_helper'
APP = YAML.load_file('config/application.yml')

describe 'Reports Show Page', :type => :feature do
  before do
    set_auth()
  end
  context "page structure" do
        describe "ui setup" do
            it "returns user to report show page" do           
              visit report_path(@report.id)
              ["Insights","Notes","Comments"].each do |text|
                page.should have_content text 
              end
            end
            it 'should be having new work icon', js: true do
              within(".slider-action-bar"){page.should have_css("#new-work-icon")}
            end
            it 'should be able to get journal,values and export options in slider-action-bar', js: true do
              within(".slider-action-bar"){find("#new-work-icon")}.click()
              within(".slider-action-bar"){all("a")}.count==3
            end
        end
  end
  context "Reports Show Page" do
      describe "Adding values" do
        it "one single value", js: true do 
        end
        it "by csv", js: true do 
        end
        it "Create Journal", js: true do 
          verify_report_show_paths
          within(".slider-action-bar"){find("#new-work-icon")}.click()
          sleep 2
          within(".slider-action-bar"){all("a")}[1].click()
          page.should have_content "New Journal for report #{@report.title}"
          fill_in("description",:with=>"Test Description")
          fill_in("report_etb_values_1_amount",:with=>"116")
          click_button("Book Journal")
          page.should have_content "Journal saved successfully. Please reload the page if you require to see the value included in your view."
        end
      end

      context "Share report" do 
        before do
          2.times do 
            FactoryGirl.create(:user)
          end 
          verify_report_show_path
          within(".grid-items"){first(".grid-item")}.click();
          ["Share with Google","Share with Profit Bees"].each do |button_text| 
            page.should have_button button_text
          end
        end

        describe do 
          it "share report with google", js: true do             
            click_button("Share with Google")
            sleep 2
            page.should have_css("#google_friends_list")
            # we dont have friends for this google user
          end

          it "share report with profitbees", js: true do
            click_button("Share with Profit Bees")
            sleep 3
            page.should have_css("#friends_list")
            fill_in("friends_list",:with=> User.last.email)
            sleep 3
            within("#friends") do 
              page.should have_content User.last.email
              find("a",:text=>"Share").click
            end
            sleep 1
             page.should have_content text "Successfully shared Ledger with: "
          end
        end
      end
  end
  # helper
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

  def verify_report_show_path
    page.should have_link "Hives"
    visit report_path(@report.id)
    ["Insights","Notes","Comments"].each do |text|
      page.should have_content text 
    end
  end

end
