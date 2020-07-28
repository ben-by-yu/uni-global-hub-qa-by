Given /^I login to user portal as "(.*)"$/ do |role|
  visit env_config[:agent_hub_host]
  find('a', :text => 'Log out').click rescue nil
  user_portal_page.login role
end


Then(/^I verify my account information is correct$/) do
  user_portal_page.verify_account_info
end


Then(/^I navigate to "([^"]*)" in "([^"]*)" section$/) do |name, section_name|
  user_portal_page.navigate_to(name, section_name)
end

Then(/^I download flyer of "([^"]*)" section$/) do |section_name|
  user_portal_page.download_flyer section_name
end

Then(/^I add "([^"]*)" section to favorite$/) do |section_name|
  user_portal_page.add_to_favorite section_name
end

And(/^I verify item is added to favorite$/) do
  step 'I navigate to "Favourite" in "tab" section'
  user_portal_page.verify_favorite_section
end

Then(/^I verify preview and download function$/) do
  user_portal_page.verify_preview_download
end

Then(/^I add item to favorite$/) do
  user_portal_page.add_to_favorite
end

And(/^I verify the requester is pending for approval$/) do
  step 'I login to user portal as "AutomationRequester"'
  login_desc = find("div[class='main'] > div[class='container'] > p[class='desc']").text
  fail 'Failed when requester landing in pending approval page!' unless login_desc == 'Your registration is pending for verification, please try again after you received the confirmation email.'
end

Then(/^I log out from user portal$/) do
  find('a', :text => 'Log out').click
end

And(/^I verify item is added to section "([^"]*)"$/) do |section_name|
  user_portal_page.verify_added_item section_name
end