require 'spec_helper'

feature 'Authentication spec', type: :request do

  scenario 'User logs in with google account', js: true do
    visit '/'
    expect(page).to have_selector('#gConnect')
    click_button('googleLogin')
  end

end
