#Setup DB NLS language settings to fetch Extended Ascii Characters
# To find the DB Char set in Oracle DB:
# select value from nls_database_parameters where parameter='NLS_CHARACTERSET';
ENV['NLS_LANG'] ||= 'AMERICAN_AMERICA.AL32UTF8'

require 'capybara'
require 'capybara/cucumber'
require 'rspec/expectations'
require 'selenium-webdriver'
require 'capybara/rspec'
require_relative 'config'
require 'rest_client'
require 'byebug'

module Logging
  def logger
    @logger ||= Logger.new(STDOUT)
  end
end

module CustomWorld
  include Logging
  delegate :test_env, :env_config, :user_config, to: Config
  delegate :deployment, to: :execution_data
  attr_reader :execution_data

  def test_driver
    (ENV['TEST_BROWSER'] || env_config[:driver]).to_sym
  end

  def base_path
    current_url.split('#')[0]
  end

  def user_info(role)
    env_config[:users][role].first
  end

  def execution_data
    @execution_data ||= ExecutionData.new
  end

  def within_visible_frame(&block)
    raise 'Block missing' unless block_given?
    if page.has_no_selector?(:frame, visible: true)
      block.call
    else
      visible_frame = first(:frame, visible: true)
      within_frame(visible_frame, &block)
    end
  end

  def method_missing(method_name, *args)
    @page_loader ||= PageLoader.new
    page = @page_loader.page(self, method_name) rescue super
    return page if page
    super
  end

  def exec_with_sleep(sleep_time=1, &block)
    block.call
    sleep(sleep_time)
  end
end

World(CustomWorld)

Capybara.configure do |config|
  config.run_server = false
  config.default_max_wait_time = 5
  config.predicates_wait = false
end