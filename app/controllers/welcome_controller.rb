class WelcomeController < ApplicationController

  skip_before_filter :verify_token, except: [:disconnect, :sign_out_user]

  def index
    @login_url = get_login_url
    if !session[:state]
      state = (0...13).map{('a'..'z').to_a[rand(26)]}.join
      session[:state] = state
    end
    @state = session[:state]
  end

  def connect
    @result = "New connection made"
    unless session[:token]
      if session[:state]==params[:state]
         set_google_service_auths            
         url = root_url # Need to confirm
      elsif params.include? :code 
        get_or_create_user_auth(get_email_for_office_365,"Office 365")
        url = auth_landing_welcome_index_url
      else
        @result = "The client state does not match the server state."
        url = root_url
      end
    else
      check_for_expired_token
      url = root_url
    end
    respond_to do |format|
      format.html { redirect_to url, notice:  @result }
      format.json {render json: @result.to_json}
    end    
  end

  def auth_office_365
    respond_to do |format|
      format.html { redirect_to root_path, notice: "Error" }
      format.js
    end
  end

  def sign_out_user
    reset_session
    respond_to do |format|
      format.html { redirect_to root_path, notice: "Signed Out Boss" }
      format.js
    end
  end

  def disconnect
    #for revoking GoogleApp
    token = session[:token]
    reset_session
    google_service.disconnect_user(token)
    render json: 'User disconnected.'.to_json
  end

  def auth_landing; end

private

#google
  def set_google_service_auths
    google_service.parse_access_codes(request)
    set_app_user_session(google_service.session)
    get_or_create_user_auth(session[:email],"google_api",session[:uid])
  end

#window
  def get_email_for_office_365
    token = get_token_from_code params[:code]
    set_user_session({:token=> token.token})
    get_email_from_id_token token.params['id_token']
  end

#common
  def get_or_create_user_auth(email,provider,auth_id=nil)
    @user = User.find_or_create_by(uid: session[:uid], email: email,provider: provider)
    set_user_session({:user_id=>@user.id,:provider=>@user.provider})
    @user
  end

# unless token expired
  def check_for_expired_token
      @result = google_service.check_user_session(session[:token])
      if @result.status == 200
        @result = @result.data                
      else
        reset_session
        @result = "Invalid Credentials, app session cleared"
      end
  end
  
  def set_app_user_session _GoogleAuthInfo
    _GoogleAuthInfo.each_pair do |key, value|
          session[key] = value
     end
  end
end
