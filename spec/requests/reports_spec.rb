require 'spec_helper'

describe 'Reports', type: :request do

  # background do
  # end

  scenario 'User add a new value from Reports show page', js: true do
    @current_user = FactoryGirl.create(:user)
    @report = FactoryGirl.create(:report, user_id: @current_user.id)
    ApplicationController.any_instance.stub(:current_user){ @current_user }
    ApplicationController.any_instance.stub(:verify_token){ '265378652378682786237846' }
    visit report_path(@report)
    expect(page).to have_link('Values.new', visible: false)
    page.execute_script("$('.book_li').find('ul').show()")
    click_link('Values.new')
    expect(page).to have_field :value_mitag
    expect(page).to have_field :value_amount
    expect(page).to have_select :value_repdate_2i
    expect(page).to have_select :value_repdate_1i
    expect(page).to have_select :value_ifrstag
    fill_in "value_mitag", :with => "Tag 1"
    fill_in "value_amount", :with => "100"
    click_button('Book Value')
    expect(page).to have_content('Value saved successfully.')
  end
end
