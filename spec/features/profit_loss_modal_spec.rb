require 'rails_helper'

feature 'user reports index page' do
    before do
      @current_user = FactoryGirl.create(:user)
      @report = FactoryGirl.create(:report)
      @note = FactoryGirl.create(:note)
      @comment = FactoryGirl.create(:comment)
      @current_user.reports << @report
      @report.notes << @note
      @report.comments << @comment
      ApplicationController.any_instance.stub(:verify_token)
      ApplicationController.any_instance.stub(:current_user){ @current_user }
    end
    describe "Notes/new" do
      it "should be able to open a popup" do
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
