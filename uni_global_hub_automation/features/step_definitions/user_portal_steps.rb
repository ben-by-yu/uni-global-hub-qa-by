Given /^I login to user portal as "(.*)"$/ do |role|
  visit env_config[:host]
  credentials = user_credentials role
  user_portal_page.login credentials[:username], credentials[:password]
end

