Feature: Global Agent Hub User Portal

  Scenario:
    Given I login to user portal as "AutomationTester"
    Then I verify my account information is correct
    Then I navigate to "Home" in "tab" section
    And I navigate to "Program Flyer" in "content" section
    Then I add "UNSW Sydney International Scholarship & Awards Flyer" section to favorite
    And I verify section is added to favorite

#  Scenario:
#    Given I login to admin portal as "AdminUser"