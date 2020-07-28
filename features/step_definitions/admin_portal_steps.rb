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

Then(/^I navigate to sidebar item "([^"]*)"$/) do |sidebar_item|
  find("section[class='sidebar'] > ul[class='sidebar-menu '] > li > a > span", :text => "#{sidebar_item}").click
  sleep 3
end

And(/^I add items for section "([^"]*)"$/) do |section_name|
  admin_portal_page.add_item section_name
end

Then(/^I log out from admin portal$/) do
  find("li[class='dropdown user user-menu'] > a > span", :text => 'Admin').click
  find("i[class='fa fa-sign-out']").click
end

And(/^I delete added item from section "([^"]*)"$/) do |section_name|
  admin_portal_page.delete_item section_name
end


And(/^I delete user "([^"]*)"$/) do |role|
  email = user_info(role)["Email address"]
  db_query.delete_test_user email
end
