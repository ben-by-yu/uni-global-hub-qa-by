require_relative 'generic_page'

class UserPortalPage < GenericPage

  def login(role)
    execution_data.user_info = user_info role
    find("input[placeholder='E-mail']").set execution_data.user_info["Email address"]
    find("input[placeholder='Password']").set execution_data.user_info["Password"]
    find("div[class='submit']", :text => "Login").click
    # click_button 'Login'
  end

  def verify_account_info
    find('p', :text => 'My Account').click
    diffs = []
    execution_data.user_info.reject {|k,v| k == 'Password'}.each do |key, value|
      ui_value = find("div[class='list_item']", :text => /#{key}/).text.gsub(":", "").gsub(" ", "_").camelize
      expected_value = (key + ' ' + value).gsub(":", "").gsub(" ", "_").camelize
      unless ui_value == expected_value
        ui_field_value = find("div[class='list_item']", :text => /#{key}/).text.split(":")[1]
        diffs << "Expected #{key} to be #{value}, but got #{ui_field_value}"
      end
    end
    raise "Found #{diffs.size} difference while comparing.\n#{diffs.join("\n")}" unless diffs.empty?
  end

  def navigate_to(name, section_name)
    section_name.upcase!
    banner = ''

    case section_name
    when 'TAB'
      find('a', :text => name).click
      if name == 'Home'
        banner = find("main > div > div[class='banner'] > h2").text
      else
        banner = find("div[class='common_title'] > h2").text
      end

    when 'CONTENT'
      find('p', :text => name).click
      # banner = find("main > div > div > div > h2").text
      banner = find("div[class='common_title'] > h2").text
    else
      fail "Invalid section type #{section_name}"
    end

    expected_banner = TabBanner.const_get(name.upcase.gsub(' ', '_'))
    raise 'Home page load error!' unless banner == expected_banner
  end

  def download_flyer(section_name)
    find("div[class='content'] > div[class='right'] > div[class='icons'] > a").click
    page.driver.browser.switch_to.window(page.driver.browser.window_handles.last)
  end

  def add_to_favorite
    execution_data.favorite_section= first("div[class='content'] > div[class='left'] > h2").text
    # find("div[class='content'] > div[class='right'] > div[class='icons'] > i").click
    first("div[class='content'] > div[class='right'] > div[class='icons'] > i").click
  end

  def verify_favorite_section
    ui_value = find("div[class='content'] > div[class='left'] > h2").text
    raise 'Item is not added to favourite.' unless ui_value == execution_data.favorite_section

    find("div[class='content'] > div[class='right'] > div[class='icons'] > i").click
  end

  def verify_preview_download
    # Verify preview function
    first("div[class='el-image'] > img").click
    first("div[class='el-image'] > div > span[class='el-image-viewer__btn el-image-viewer__close'] > i[class='el-icon-circle-close']").click

    # Verify pdf download
    attachment_url = first("div[class='content'] > div[class='right'] > div[class='icons'] > a")[:href]
    first("div[class='content'] > div[class='right'] > div[class='icons'] > a").click
    if attachment_url.match? /.*pdf?/
      page.driver.browser.switch_to.window(page.driver.browser.window_handles.last)
      raise 'PDF document cannot be opened properly!' unless attachment_url == URI.parse(page.current_url).to_s
    end

    page.driver.browser.close()
    page.driver.browser.switch_to.window(page.driver.browser.window_handles.first)
  end

end
