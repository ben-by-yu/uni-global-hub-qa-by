Given /^I login to user portal as "(.*)"$/ do |role|
  visit env_config[:agent_hub_host]
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

And(/^I verify section is added to favorite$/) do
  step 'I navigate to "Favourite" in "tab" section'
  user_portal_page.verify_favorite_section
end