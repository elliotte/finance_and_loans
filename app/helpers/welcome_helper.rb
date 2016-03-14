module WelcomeHelper
  
  #WINDOWS AUTH HELPERS USED IN WELCOME CONTROLLER
  def get_login_url
    client = initialize_window_client
    login_url = client.auth_code.authorize_url(:redirect_uri => ENV['WINDOWS_REDIRECT_URI'], :scope => SCOPES.join(' '))
  end

  # O365 AuthLogin Helper
  SCOPES = [ 'openid', 'https://outlook.office.com/mail.read' ]
  def get_token_from_code(auth_code)
    client = initialize_window_client
    token = client.auth_code.get_token(auth_code,
                                     :redirect_uri => authorize_url,
                                       :scope => SCOPES.join(' '))
  end
  # O365 AuthLogin Helper
  def get_email_from_id_token(id_token)
    token_parts = id_token.split('.')
    encoded_token = token_parts[1]
    leftovers = token_parts[1].length.modulo(4)
    if leftovers == 2
      encoded_token += '=='
    elsif leftovers == 3
      encoded_token += '='
    end
    decoded_token = Base64.urlsafe_decode64(encoded_token)
    jwt = JSON.parse(decoded_token)
    #breaks here...
    email = jwt['preferred_username']
  end

  # O365 AuthClient
  def initialize_window_client
    OAuth2::Client.new(ENV['WINDOWS_CLIENT_ID'],
                                ENV['WINDOWS_CLIENT_SECRET'],
                                :site => 'https://login.microsoftonline.com',
                                :authorize_url => '/common/oauth2/v2.0/authorize',
                                :token_url => '/common/oauth2/v2.0/token')
  end

end
