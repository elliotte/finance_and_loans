class ApplicationController < ActionController::Base
  
  protect_from_forgery with: :exception
  before_filter :verify_token
  
  include ApplicationHelper

  $authorization = Signet::OAuth2::Client.new(
      :authorization_uri => ENV['AUTH_URI'],
      :token_credential_uri => ENV['TOKEN_URI'],
      :client_id => ENV['CLIENT_ID'],
      :client_secret => ENV['CLIENT_SECRET'],
      :redirect_uri => ENV['REDIRECT_URIS'],
      :scope => ENV['PLUS_LOGIN_SCOPE'])
  $client = Google::APIClient.new(:application_name => 'ProfitBees',
                              :application_version => '1.0.0')

  # THIS IS MASTER TEXT FOR DB ENTRY AND SESSION LOOKUP NOT CAPITALISED O"
  $O365_provider_ID = "Office365"

  def verify_token
    # Check for stored credentials in the current user's session.
    if !session[:token]
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'You are not authorized to access this page.' }
        format.json { 'User is not connected.'.to_json }
      end
    else
      google_service.set_auth(session[:token]) unless session[:provider].include?("Office365")
    end
  end
  
  def current_user
    @user ||= User.find(session[:user_id]) unless session[:user_id].blank?
  end
  # useful when the functionality is something that's used between both the controller and the view
  helper_method :current_user
  
  def google_service
    @google_service ||= GoogleService.new($client, $authorization)
  end

  def date_from_params(params, key)
    date_parts = params.select { |k,v| k.to_s =~ /\A#{key}\([1-6]{1}i\)/ }.values
    date_parts[0..2].join('-') + ' ' + date_parts[3..-1].join(':')
  end
  
end
