Given(/^I login to admin portal as "([^"]*)"$/) do |role|
  visit env_config[:admin_portal_host]
  credentials = user_info role
  admin_portal_page.login credentials[:Username], credentials[:Password]
end

Given(/^I sign up as "([^"]*)"$/) do |role|
  visit env_config[:agent_hub_host]
  admin_portal_page.sign_up role
end

And(/^I approve new user request$/) do
  admin_portal_page.approve_new_user
end