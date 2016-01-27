Before('@g_plus_stub') do
	$authorization = Signet::OAuth2::Client.new(
      :authorization_uri => "localhost:3000/oauth/token",
      :token_credential_uri => "localhost:3000/oauth/token",
      :client_id => "11111111",
      :client_secret => "ffsdff1hftg34",
      :redirect_uri => "localhost:3000/oauth/token",
      :scope => ENV['PLUS_LOGIN_SCOPE'])
  $client = Google::APIClient.new(:application_name => 'ProfitBees',
                              :application_version => '1.0.0')

  	@current_user = FactoryGirl.create(:user)
  	@cash_book = FactoryGirl.create(:cash_ledger)  
  	@report = FactoryGirl.create(:report,user_id: @current_user.id)
  	
    #stub doesnot work for features
    # ApplicationController.any_instance.stub(:verify_token)
   #  ApplicationController.any_instance.stub(:current_user){ @current_user }
end