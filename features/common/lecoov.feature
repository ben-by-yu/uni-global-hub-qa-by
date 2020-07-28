Feature: Global Agent Hub User Portal

  Scenario: User log in
    Given I login to user portal as "AutomationTester"
    Then I verify my account information is correct
    Then I navigate to "Home" in "tab" section
    And I navigate to "Program Flyers" in "content" section
    Then I verify preview and download function
    Then I add item to favorite
    And I verify item is added to favorite
    Then I navigate to "Home" in "tab" section
    And I navigate to "Pull Up Banners" in "content" section
    Then I verify preview and download function
    Then I add item to favorite
    And I verify item is added to favorite
#    Then I navigate to "Home" in "tab" section
#    And I navigate to "Brand Guidelines" in "content" section
#    Then I verify preview and download function
#    Then I add item to favorite
#    And I verify item is added to favorite
    Then I log out from user portal

  Scenario: Add new item to content
    Given I login to admin portal as "AdminUser"
    Then I navigate to sidebar item "Content Management"
    And I add items for section "Program Flyers"
    Then I log out from admin portal
    Then I login to user portal as "AutomationTester"
    And I verify item is added to section "Program Flyers"
    Then I log out from user portal
    Then I login to admin portal as "AdminUser"
    Then I navigate to sidebar item "Content Management"
    And I delete added item from section "Program Flyers"
    Then I log out from admin portal

  Scenario: User sign up
    Given I sign up as "AutomationRequester"
    And I verify the requester is pending for approval
    Then I login to admin portal as "AdminUser"
    And I approve new user request
    Then I login to user portal as "AutomationRequester"
    And I verify my account information is correct
    Then I log out from user portal
    And I delete user "AutomationRequester"