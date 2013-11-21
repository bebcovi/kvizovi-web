require "exception_notification"

Lektire::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Use the routes to render HTTP-error pages instead of rendering static ones
  config.exceptions_app = self.routes

  config.eager_load = true

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = true

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = true

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "//d9bybmcyeuhn7.cloudfront.net"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # ActionMailer configuration
  config.action_mailer.smtp_settings = {
    address:        'smtp.sendgrid.net',
    port:           '587',
    authentication: :plain,
    user_name:      ENV["SENDGRID_USERNAME"],
    password:       ENV["SENDGRID_PASSWORD"],
    domain:         'herokuapp.com'
  }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.default_url_options = {host: "kvizovi.org"}

  # Email exceptions
  config.middleware.use ExceptionNotification::Rack,
    email: {
      sender_address: "Kvizovi <#{ENV["SENDGRID_USERNAME"]}>",
      exception_recipients: ["janko.marohnic@gmail.com"],
      ignore_exceptions: [],
    }

  # Caching configuration
  config.action_controller.perform_caching = true
  config.action_view.cache_template_loading = true
end
