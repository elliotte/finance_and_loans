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
    unless session[:token]
     if (session[:state] == params[:state])
      set_google_service_auths unless params.include? :code
      email = ((params.include? :code)? get_email_for_office_365 : session[:email])
      get_or_create_user_auth(email,session[:gplus_id])
      redirect_to root_url and return if @user.nil?
      render json: "New connection made".to_json
     elsif params.include? :code 
       email = get_email_for_office_365
       get_or_create_user_auth(email)
       redirect_to auth_landing_welcome_index_path
     else
      render json: 'The client state does not match the server state.'.to_json
     end
    else
      result = google_service.check_user_session(session[:token])
      if result.status == 200
        result = result.data
        render json: result.to_json
      else
        reset_session
        result = "Invalid Credentials, app session cleared".to_json
        render json: result
     end
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

  def set_google_service_auths
    access_codes = google_service.parse_access_codes(request)
    google_service.set_session(access_codes)
    set_app_user_session(google_service.session)
  end

  def get_email_for_office_365
    token = get_token_from_code params[:code]
    session[:token] = token.token
    email = get_email_from_id_token token.params['id_token']
  end

  def get_or_create_user_auth(email,auth_id=nil)
    @user = User.find_or_create_by(uid: session[:gplus_id], email: email)
    session[:user_id] = @user.id
    session[:provider] = "Office 365" if @user.uid.blank?
  end
  
  def set_app_user_session _GoogleAuthInfo
    _GoogleAuthInfo.each_pair do |key, value|
          session[key] = value
     end
  end

end
