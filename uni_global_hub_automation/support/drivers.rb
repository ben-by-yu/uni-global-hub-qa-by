require_relative 'env'

Capybara.register_driver :chrome do |app|
  case RbConfig::CONFIG['host_os']
    when /mswin|mingw/
      chrome_options = Selenium::WebDriver::Chrome::Options.new
      chrome_switches = %w[--ignore-certificate-errors --disable-popup-blocking --disable-translate --disable-infobars --disable-password-manager]
      chrome_switches.each do |option|
        chrome_options.add_argument(option)
      end
      chrome_options.add_preference(:download, { prompt_for_download: false })
      chrome_options.add_preference(:credentials_enable_service, false)

      Capybara::Selenium::Driver.new(app,
                                     browser: :chrome,
                                     driver_path: 'webdrivers/chromedriver-2.44.exe',
                                     options: chrome_options)

    when /linux|bsd/
      Capybara::Selenium::Driver.new(app,
                                     browser: :chrome,
                                     driver_path: 'webdrivers/chromedriver_linux64_2.44',
                                     options: Selenium::WebDriver::Chrome::Options.new(args: ['disable-gpu', 'window-size=1920,1080', 'aggressive-cache-discard', 'ignore-certificate-errors', 'disable-popup-blocking', 'disable-translate', 'disable-infobars', 'disable-password-manager']))
  end
end

Capybara.register_driver :chrome_grid do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      chromeOptions: {args: %w[disable-gpu ignore-certificate-errors disable-popup-blocking disable-translate disable-infobars disable-password-manager window-size=1920,1080]}
  )

  Capybara::Selenium::Driver.new(app,
                                 browser: :remote,
                                 url: Config.env_config[:selenium_grid],
                                 desired_capabilities: capabilities
  )
end

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      chromeOptions: {args: %w[headless disable-gpu window-size=1920,1080]}
  )

  Capybara::Selenium::Driver.new(
      app,
      browser: :chrome,
      driver_path: 'webdrivers/chromedriver-2.36.exe',
      desired_capabilities: capabilities
  )
end

Capybara.register_driver :ie do |app|
  caps = Selenium::WebDriver::Remote::Capabilities.internet_explorer(:ensureCleanSession => true, :browserCommandLineSwitches => private, :ACCEPT_SSL_CERTS => true, :INTRODUCE_FLAKINESS_BY_IGNORING_SECURITY_DOMAINS => true, :nativeEvents => true, :enablePersistentHover => false)
  Capybara::Selenium::Driver.new(app, :browser => :internet_explorer, :desired_capabilities => caps)
end