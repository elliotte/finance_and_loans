Before('@g_plus_stub') do
  	@current_user = FactoryGirl.create(:user)
  	@cash_book = FactoryGirl.create(:cash_ledger)  
  	ApplicationController.any_instance.stub(:verify_token)
    ApplicationController.any_instance.stub(:current_user){ @current_user }
end