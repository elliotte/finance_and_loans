require 'rails_helper'

module Auth
	class << self 
		def user_auth
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
		end
	end
end