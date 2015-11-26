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

  def gettoken
    
    token = get_token_from_code params[:code]
    session[:token] = token.token
    session[:email] = get_email_from_id_token token.params['id_token']
    redirect_to root_path 
  end

  def connect
    if !session[:token]
        if session[:state] == params[:state]
          access_codes = google_service.parse_access_codes(request)
          google_service.set_session(access_codes)
          set_app_user_session(google_service.session)
          @user = User.find_or_create_by(uid: session[:gplus_id], email: session[:email])
          redirect_to(action: "/") and return if @user.nil?
          render json: "New connection made".to_json
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

  def sign_out_user
    reset_session
    respond_to do |format|
      format.html { redirect_to root_path, notice: "Signed Out Boss" }
      format.js
    end
  end

  def disconnect
    token = session[:token]
    reset_session
    google_service.disconnect_user(token)
    render json: 'User disconnected.'.to_json
  end

  def set_app_user_session _GoogleAuthInfo
     _GoogleAuthInfo.each_pair do |key, value|
          session[key] = value
     end
  end

  def auth_landing
  end


end
