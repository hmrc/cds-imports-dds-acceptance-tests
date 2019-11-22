@acceptance
Feature: Submit raw XML import declarations to the declarations API

  Background:
    Given the mongo database is empty
    And our application is registered with the DEC-API

  Scenario: Submit a declaration with malformed XML
    Given I am signed in as a registered user
    When I navigate to the Submit Declaration page
    And I submit the declaration with malformed xml
    Then I should see malformed xml error with following details
      | errorHeading | errorMessage                   | errorLinkText                    |
      | Error        | There was an error on the form | This is not a valid XML document |

  Scenario: Submit a declaration with invalid XML (doesn't match schema)
    Given I am signed in as a registered user
    When I navigate to the Submit Declaration page
    And I submit the declaration with invalid xml
    Then I should see submitted page with the following response details for invalid xml
      | Status |
      | 400    |

  Scenario: Submit a valid declaration xml with valid data
    Given I am signed in as a registered user
    When I navigate to the Submit Declaration page
    And I submit the declaration with valid data
    Then I should see submitted page with the following response details for valid data
      | Status |
      | 202    |