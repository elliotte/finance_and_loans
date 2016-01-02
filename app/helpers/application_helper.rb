module ApplicationHelper

  def route_has_pattern(request_path, pattern)
    (request_path =~ /#{pattern}/i) != nil
  end

  # OLD SKYDRIVE CODE DISCONNECTED 2/2/15

  # def set_sky_drive_login
  #   redirect_url = ENV['CALLBACK_URL']
  #   scope = "wl.skydrive_update,wl.offline_access"
  #   $sky_drive_client = Skydrive::Oauth::Client.new(ENV['SKY_DRIVE_CLIENT_ID'],ENV['SKY_DRIVE_SECRET'], redirect_url, scope)      
  #   $sky_drive_client.authorize_url
  # end

  # def post_http_request_report(params)
  #   url = 'https://apis.live.net/v5.0/me/skydrive'
  #   header={ 'Content-Type' => 'application/json', 'Authorization' => "Bearer #{session[:sky_drive_token]}" } 
  #   encoded = JSON.generate({name: params["report"]["title"]}  )
  #   response = RestClient.post(url, encoded, header) rescue ""
  # end

end

 