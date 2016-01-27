ENV['WINDOWS_CLIENT_ID'] = '0805eae6-bdf8-49c2-93cf-5a8aced01b36' 
ENV['WINDOWS_CLIENT_SECRET'] = 'pVCdXWDYnK9jB3brsoqmYUU' 
ENV['WINDOWS_REDIRECT_URI'] = 'http://localhost:3000/authorize'
ENV['SKY_DRIVE_CLIENT_ID']='000000004017A352'
ENV['SKY_DRIVE_SECRET']='O8pgsKgK-fVxG2ScWsGb2ZM1UqFT5iDq'
ENV['REGIRECT_URI']= "https://login.live.com/oauth20_desktop.srf"
ENV['CALLBACK_URL']= "http://localhost:3000/reports"

Draftapp::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = true
  config.middleware.use RackSessionAccess::Middleware
  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = false
  # Configure static asset server for tests with Cache-Control for performance.
  config.serve_static_files  = true
  config.static_cache_control = "public, max-age=3600"

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr
end
