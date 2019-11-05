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
    When I click on the link View the status of your declaration
    Then I should see the heading "Customs Declaration submitted"
    And the declaration status should be ACCEPTED

  Scenario: Receive and display Rejected notification with errors from DMS
    And I am signed in as a registered user
    When I navigate to the Submit Declaration page
    And I submit the declaration with incorrect data
    Then I should see submitted page with the following response details for valid data
      | Status |
      | 202    |
    When I click on the link View the status of your declaration
    Then I should see the heading "Customs Declaration submitted"
    And the declaration status should be REJECTED
    And I should see the following errors
    | Data Error: Data Element contains invalid value (CDS10020)Declaration (42A, -, -)GoodsShipment (67A, -, -)GovernmentAgencyGoodsItem (68A, 1, -)AdditionalDocument/LPCOExemptionCode (02A, 2, 360) |
