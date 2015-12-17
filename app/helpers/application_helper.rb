module ApplicationHelper

  def route_has_pattern(request_path, pattern)
    (request_path =~ /#{pattern}/i) != nil
  end

  SCOPES = [ 'openid', 'https://outlook.office.com/mail.read' ]
 
  #WINDOWS AUTH HELPERS USED IN WELCOME CONTROLLER
  def get_login_url
    client = initialize_window_client
    login_url = client.auth_code.authorize_url(:redirect_uri => ENV['WINDOWS_REDIRECT_URI'], :scope => SCOPES.join(' '))
  end

  def get_token_from_code(auth_code)
    client = initialize_window_client
    token = client.auth_code.get_token(auth_code,
                                     :redirect_uri => authorize_url,
                                       :scope => SCOPES.join(' '))
  end
  
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
    email = jwt['preferred_username']
  end

  def initialize_window_client
    OAuth2::Client.new(ENV['WINDOWS_CLIENT_ID'],
                                ENV['WINDOWS_CLIENT_SECRET'],
                                :site => 'https://login.microsoftonline.com',
                                :authorize_url => '/common/oauth2/v2.0/authorize',
                                :token_url => '/common/oauth2/v2.0/token')
  end
  
  def set_sky_drive_login
    redirect_url = ENV['CALLBACK_URL']
    scope = "wl.skydrive_update,wl.offline_access"
    $sky_drive_client = Skydrive::Oauth::Client.new(ENV['SKY_DRIVE_CLIENT_ID'],ENV['SKY_DRIVE_SECRET'], redirect_url, scope)      
    $sky_drive_client.authorize_url
  end

  def post_http_request_report(params)
    url = 'https://apis.live.net/v5.0/me/skydrive'
    header={ 'Content-Type' => 'application/json', 'Authorization' => "Bearer #{session[:sky_drive_token]}" } 
    encoded = JSON.generate({name: params["report"]["title"]}  )
    response = RestClient.post(url, encoded, header) rescue ""
  end
end

 