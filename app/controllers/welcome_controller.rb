class WelcomeController < ApplicationController

skip_before_filter :verify_token, except: [:disconnect, :sign_out_user]

  def index
    if !session[:state]
      state = (0...13).map{('a'..'z').to_a[rand(26)]}.join
      session[:state] = state
    end
    @state = session[:state]
  end

  def connect
    if !session[:token]
        if session[:state] == params[:state]
          access_codes = google_service.parse_access_codes(request)
          google_service.set_session(access_codes)
          set_app_user_session(google_service.session)
          @user = User.find_or_create_by(uid: session[:gplus_id], email: session[:email])
          render json: "New connection made".to_json
        else
          render json: 'The client state does not match the server state.'.to_json
        end
    else
        #to change to gProfile so smaller call..
        google_service.get_user_files(session[:token])
        result = google_service.files
        case 
        when result.has_key?('error')
          reset_session
          render json: "Invalid Credentials, app session cleared".to_json
        when result.has_key?('kind')
          #to cache files to localStorage?  CurrentJS fetches again after result render
          #google_service.set_files(result.to_json)
          render json: result.to_json
        end
    end
  end

  # def do_something
  #   redirect_to(action: "/index") and return if @user.nil?
  #   render action: "overthere" # won't be called if monkeys is nil
  # end

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

  def set_app_user_session google_session_info
     google_session_info.each_pair do |key, value|
          session[key] = value
     end
  end


end
