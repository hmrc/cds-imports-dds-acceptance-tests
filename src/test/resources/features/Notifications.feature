@acceptance
Feature: Receive notifications from DMS

  Background:
    Given the mongo database is empty
    And our application is registered with the DEC-API
  @zap
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


  Scenario: Receive and display tax liability notification with errors from DMS
    And I am signed in as a registered user
    When I navigate to the Submit Declaration page
    And I submit the declaration with tax liability
    Then I should see submitted page with the following response details for tax liability
      | Status |
      | 202    |
    When I click on the link View the status of your declaration
    Then I should see the heading "Customs Declaration submitted"
    And the declaration status should be TAX_LIABILITY

  Scenario: Receive and display insufficient balance notification with errors from DMS
    And I am signed in as a registered user
    When I navigate to the Submit Declaration page
    And I submit the declaration with insufficient balance
    Then I should see submitted page with the following response details for insufficient balance
      | Status |
      | 202    |
    When I click on the link View the status of your declaration
    Then I should see the heading "Customs Declaration submitted"
    And the declaration status should be INSUFFICIENT_BALANCE_IN_DAN

  Scenario: Receive and display insufficient balance reminder notification with errors from DMS
    And I am signed in as a registered user
    When I navigate to the Submit Declaration page
    And I submit the declaration with insufficient balance reminder
    Then I should see submitted page with the following response details for insufficient balance reminder
      | Status |
      | 202    |
    When I click on the link View the status of your declaration
    Then I should see the heading "Customs Declaration submitted"
    And the declaration status should be INSUFFICIENT_BALANCE_IN_DAN_REMINDER
