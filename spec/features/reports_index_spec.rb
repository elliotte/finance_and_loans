require 'rails_helper'

feature 'user reports index page' do
    # before do
    #         @current_user = FactoryGirl.create(:user)
    #         @report = FactoryGirl.create(:report)
    #         @current_user.reports << @report
    #         ApplicationController.any_instance.stub(:verify_token)
    #         ApplicationController.any_instance.stub(:current_user){ @current_user }
    # end
    # describe "reports/index" do
    #     it "returns user ledgers on index page" do
    #       visit reports_path
    #       page.should have_content("New report testing")
    #     end
    #     it 'should be able to use an ajax form', js: true do
    #        visit reports_path
    #        page.should_not have_css("input#report_title")
    #        click_link('Report.new')
    #        page.should have_css("input#report_title")
    #     end
    #     it 'should be able to add a report', js: true do
    #        visit reports_path
    #        click_link('Report.new')
    #        fill_in 'report[title]', with: 'I love Rails!'
    #        #can't click as http post method test == js?
    #        #click_button('Create Report')
    #     end
    #     it 'should be able to add a new UKGAAP', js: true do
    #        visit reports_path
    #        click_link('UKGAAP.new')
    #        fill_in 'report[title]', with: 'I love Rails!'
    #     end
    # end
end
