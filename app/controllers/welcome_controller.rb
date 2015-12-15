class WelcomeController < ApplicationController

  skip_before_filter :verify_token, except: [:disconnect, :sign_out_user, :auth_landing]
  # THIS IS MASTER TEXT FOR DB ENTRY AND SESSION LOOKUP NOT CAPITALISED O"
  $O365_provider_ID = "Office365"

  def index
    # CHECK IF WINDOWS USER SIGNED IN
    if session[:provider] && session[:provider] == $O365_provider_ID
      redirect_to auth_landing_welcome_index_url
    else
      @login_url = get_login_url
      if !session[:state]
        state = (0...13).map{('a'..'z').to_a[rand(26)]}.join
        session[:state] = state
      end
      @state = session[:state]
    end
  end

  def connect
    @result = "New connection made"
    url = auth_landing_welcome_index_url
    #check for GoogleUser already signed in ( office365 user check done @welcomeINDEX )
    unless session[:token]
      #new userSignIn
      if session[:state]==params[:state]
         # FOR GOOGLE USER
         google_service.parse_access_codes(request)
         set_auth_token_session google_service.session[:token]
         set_user_and_session(google_service.session[:email],google_service.session[:uid])   
         # need to change googles_session[uid] to provider         
      elsif params.include? :code 
        # FOR WINDOWS USER
        token = get_token_from_code params[:code]
        set_auth_token_session(token.token)
        email = get_email_from_id_token token.params['id_token']
        set_user_and_session(email,$O365_provider_ID)       
      else
        # SOMETHING WENT WRONG
        @result = "The client state does not match the server state."
        url = root_url
      end
    else
      # CHECK TOKEN NOT EXPIRED
      check_for_expired_token
      url = root_url
    end
    # USED BY ALL SCENARIOS
    respond_to do |format|
      format.html { redirect_to url, notice:  @result }
      format.json {render json: @result.to_json}
    end    
  end

  def auth_landing;  end

  def sign_out_user
    reset_session
    respond_to do |format|
      format.html { redirect_to root_path, notice: "Signed Out Boss" }
      format.js
    end
  end
  #for revoking GoogleApp
  def disconnect
    token = session[:token]
    reset_session
    google_service.disconnect_user(token)
    render json: 'User disconnected.'.to_json
  end

private

  def set_user_and_session(email,auth_id)
    return_user(email, auth_id)
    set_user_session({:user_id=>@user.id,:provider=>@user.uid, email: email})
  end

  def return_user email, providerID
    # ProviderID = "Office365" for nonGoogle
    @user = User.find_or_create_by(uid: providerID, email: email)
  end

  def set_auth_token_session token
    session[:token] = token
  end

  def set_user_session(hash)
    hash.each do |key,value|
      session[key] = value
    end  
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

end
