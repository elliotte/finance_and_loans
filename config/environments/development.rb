ENV['WINDOWS_CLIENT_ID'] = '0805eae6-bdf8-49c2-93cf-5a8aced01b36' 
ENV['WINDOWS_CLIENT_SECRET'] = 'pVCdXWDYnK9jB3brsoqmYUU' 
ENV['WINDOWS_REDIRECT_URI'] = 'http://localhost:3000/authorize'
ENV['SKY_DRIVE_CLIENT_ID']='000000004017A352'
ENV['SKY_DRIVE_SECRET']='O8pgsKgK-fVxG2ScWsGb2ZM1UqFT5iDq'
ENV['REGIRECT_URI']= "https://login.live.com/oauth20_desktop.srf"
ENV['CALLBACK_URL']= "http://localhost:3000/reports"

Draftapp::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.

  #MARK changed 20-05-15 per article on slow rendering..
  config.assets.debug = false
end
