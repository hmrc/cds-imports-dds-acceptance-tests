@acceptance
Feature: Submit imports declarations to dec api

  Scenario: Submit a invalid declaration xml
    Given I am signed in as a registered user
    When I navigate to the Submit Declaration page
    And I submit the declaration with invalid xml
    Then I should see invalid xml error with following details
      | errorHeading | errorMessage                   | errorLinkText                    |
      | Error        | There was an error on the form | This is not a valid xml document |

  Scenario: Submit a valid declaration xml with invalid data
    Given I am signed in as a registered user
    When I navigate to the Submit Declaration page
    And I submit the declaration with invalid data
    Then I should see submitted page with the following response details for invalid data
      | Status |
      | 400    |

  Scenario: Submit a valid declaration xml with valid data
    Given I am signed in as a registered user
    When I navigate to the Submit Declaration page
    And I submit the declaration with valid data
    Then I should see submitted page with the following response details for valid data
      | Status |
      | 202    |