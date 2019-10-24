@acceptance @zap
Feature: Receive notifications from DMS

  Background:
    Given the mongo database is dropped
    And My app is registered to Dec API

  Scenario: Receive and display Accepted notification from DMS
    And I am signed in as a registered user
    When I navigate to the Submit Declaration page
    And I submit the declaration with correct data
    Then I should see submitted page with the following response details for valid data
      | Status |
      | 202    |
    And I wait for 2 seconds
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
    And I wait for 2 seconds
    When I click on the link View the status of your declaration
    Then I should see the heading "Customs Declaration submitted"
    And the declaration status should be REJECTED
    And I should see the following errors
    | NotificationError(CDS10020,List(ErrorPointer(42A,None,None), ErrorPointer(67A,None,None), ErrorPointer(68A,Some(1),None), ErrorPointer(02A,Some(2),Some(360)))) |
