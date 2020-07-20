Capybara::Node::Element.class_eval do
  def click_at(x, y)
    right = x - (native.size.width / 2)
    top = y - (native.size.height / 2)
    driver.browser.action.move_to(native).move_by(right.to_i, top.to_i).click.perform
  end
end

Before do |scenario|
  logger.info "Using driver: #{test_driver}"
  logger.info "Using Selenium Hub: #{Config.env_config[:selenium_grid]}" if test_driver == :chrome_grid
  @scenario_title = "#{scenario.name}#{scenario.outline? ? scenario.cell_values: ''}"
  @scenario_step_count ||= scenario.outline? ? scenario.source[1].steps.length : scenario.source[1].children.length
  @scenario_start = Time.now
  logger.info "Scenario started: #{@scenario_title}"
  Capybara.default_driver = test_driver
  Capybara.javascript_driver = test_driver
  logger.info RbConfig::CONFIG['host_os']
  Capybara.current_session.driver.browser.manage.window.maximize if RbConfig::CONFIG['host_os'].include? 'mingw'
  # Capybara.current_session.driver.browser.manage.delete_all_cookies

  if test_driver == :chrome_grid
    Capybara.current_session.driver.browser.file_detector = lambda do |args|
      # args => ["/path/to/file"]
      str = args.first.to_s
      str if File.exist?(str)
    end
  end

  # @execution_data = ExecutionData.new
end

After do |scenario|
  path = File.expand_path '../../output/failshots', __FILE__
  FileUtils.mkdir_p path
  save_screenshot "#{path}/#{DateTime.now.strftime('%Y%m%d%H%M%S')}_#{scenario.name[0..25]}.png" if scenario.failed?
  logger.info "Scenario finished: #{scenario.status}, #{(Time.now - @scenario_start).round(2)}s, #{@scenario_title}"
  # Capybara.reset_sessions!
  # Capybara.current_session.driver.reset!
end

AfterStep do |result, step|
  @step_number ||= 1
  step_in_feature_file_long = step.location.to_s
  step_in_feature_file = step_in_feature_file_long[step_in_feature_file_long.rindex("/")+1..-1]
  logger.info "Step finished, #{result}, #{@step_number} of #{@scenario_step_count}, #{step_in_feature_file}, #{step.name}"
  @step_number += 1
end
