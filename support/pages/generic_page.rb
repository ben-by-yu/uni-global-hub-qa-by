require_relative '../helpers/retry_helper'
require_relative '../models/banner'
require_relative '../models/db_query'
require 'open-uri'

class GenericPage
  include Capybara::DSL
  include Capybara::Node::Matchers
  include RSpec::Matchers
  include RetryHelper
  include TabBanner

  def initialize(world)
    @world = world
  end

  def method_missing(method_name, *args, &block)
    @world.send(method_name, *args, &block)
  end

  def click_action_button(button)
    within_visible_frame do
      if page.has_selector?("button[data-test-id='#{button}'")
        find("button[data-test-id='#{button}'").click
      else
        click_button button
      end
      #TODO remove once error saving image metadata is resolved
      sleep 0.5
      page.driver.browser.switch_to.alert.accept rescue nil
    end
    # wait_for_page_to_load
  end

  def read_pdf(url)
    puts "PDF URL: #{url}"
    file = download_file "#{DateTime.now.strftime('%Y%m%d%H%M%S')}.pdf", url
    # text_analysis = PDF::Inspector::Text.analyze_file(file)
    # pdf_text = text_analysis.strings.join(' ')
    text_analysis = PDF::Reader.new(file)
    pdf_text = text_analysis.pages.join(' ').gsub(/\n+ +/, ' ')
    puts pdf_text
    pdf_text
  end

  def download_file(file_name, url)
    file_path = "output/#{file_name}"
    open(file_path, 'wb') do |file|
      file << open(url).read
    end
    File.new(file_path)
    file_path
  end

  def get_expected_banner(tab)
    PegaStatus.module_eval(case_type.camelize).const_get(underscoreize(status).upcase)
  end

  def scroll_to(element)
    script = <<-JS
      arguments[0].scrollIntoView(true);
    JS
    Capybara.current_session.driver.browser.execute_script(script, element.native)
  end
end
