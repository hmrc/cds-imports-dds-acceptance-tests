@acceptance @zap
Feature: Receive notifications from DMS

  Background:
    Given the mongo database is empty
    And our application is registered with the DEC-API

  Scenario: Receive and display Accepted notification from DMS
    And I am signed in as a registered user
    When I navigate to the Submit Declaration page
    And I submit the declaration with correct data
    Then I should see submitted page with the following response details for valid data
      | Status |
      | 202    |
    And I wait for 5 seconds
    # ^^^ in-built notification delay in DEC-API stub is 2 seconds
    When I click on the link View the status of your declaration
    And I wait for 5 seconds
    # ^^^ FIXME subsequent steps sometimes execute before the href target page is rendered
    Then I should see the heading "Customs Declaration submitted"
    And the declaration status should be ACCEPTED

  Scenario: Receive and display Rejected notification with errors from DMS
    And I am signed in as a registered user
    When I navigate to the Submit Declaration page
    And I submit the declaration with incorrect data
    Then I should see submitted page with the following response details for valid data
      | Status |
      | 202    |
    And I wait for 5 seconds
    # ^^^ in-built notification delay in DEC-API stub is 2 seconds
    When I click on the link View the status of your declaration
    And I wait for 5 seconds
    # ^^^ FIXME subsequent steps sometimes execute before the href target page is rendered
    Then I should see the heading "Customs Declaration submitted"
    And the declaration status should be REJECTED
    And I should see the following errors
    | Data Error: Data Element contains invalid value (CDS10020)Declaration (42A - x - x)GoodsShipment (67A - x - x)GovernmentAgencyGoodsItem (68A - 1 - x)AdditionalDocument (02A - 2 - 360) |
