Before('@g_plus_stub') do

	$authorization = Signet::OAuth2::Client.new(
      :authorization_uri => ENV['AUTH_URI'],
      :token_credential_uri => ENV['TOKEN_URI'],
      :client_id => ENV['CLIENT_ID'],
      :client_secret => ENV['CLIENT_SECRET'],
      :redirect_uri => ENV['REDIRECT_URIS'],
      :scope => ENV['PLUS_LOGIN_SCOPE'])

  $client = Google::APIClient.new(:application_name => 'ProfitBees',
                              :application_version => '1.0.0')
  $client.authorization.access_token='265378652378682786237846'
  	@current_user = FactoryGirl.create(:user)
  	@cash_book = FactoryGirl.create(:cash_ledger)  
  	@report = FactoryGirl.create(:report,user_id: @current_user.id)  	
end