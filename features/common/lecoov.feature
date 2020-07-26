Feature: Global Agent Hub User Portal

  Scenario:
    Given I login to user portal as "AutomationTester"
    Then I verify my account information is correct

    Then I navigate to "Home" in "tab" section
    And I navigate to "Program Flyer" in "content" section
    Then I verify preview and download function
    Then I add item to favorite
    And I verify item is added to favorite

#    Then I navigate to "Home" in "tab" section
#    And I navigate to "Pull Up Banners" in "content" section
#    Then I verify preview and download function
#    Then I add item to favorite
#    And I verify item is added to favorite

#    Then I navigate to "Home" in "tab" section
#    And I navigate to "Brand Guidelines" in "content" section
#    Then I verify preview and download function
#    Then I add item to favorite
#    And I verify item is added to favorite

    Then I log out from user portal

#  Scenario:
#    Given I login to admin portal as "AdminUser"

#  Scenario:
#    Given I sign up as "AutomationRequester"
#    And I verify the requester is pending for approval
#    Then I login to admin portal as "AdminUser"
#    And I approve new user request
#    Then I login to user portal as "AutomationRequester"
#    And I verify my account information is correct
#    Then I log out from user portal