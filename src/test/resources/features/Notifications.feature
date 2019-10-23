@acceptance @zap
Feature: Receive notifications from DMS

  Scenario: Receive and display Accepted notification from DMS
    Given the mongo database is dropped
    And My app is registered to Dec API
    And dec api is configured to send success response message
    And I am signed in as a registered user
    When I navigate to the Submit Declaration page
    And I submit the declaration with valid data
    Then I should see submitted page with the following response details for valid data
      | Status |
      | 202    |
    And I wait for 2 seconds
    When I click on the link View the status of your declaration
    Then I should see the heading "Customs Declaration submitted"
    And the declaration status should be ACCEPTED

  Scenario: Receive and display Rejected notification with errors from DMS
    Given the mongo database is dropped
    And My app is registered to Dec API
    And dec api is configured to send a rejected response message
    And I am signed in as a registered user
    When I navigate to the Submit Declaration page
    And I submit the declaration with valid data
    Then I should see submitted page with the following response details for valid data
      | Status |
      | 202    |
    And I wait for 2 seconds
    When I click on the link View the status of your declaration
    Then I should see the heading "Customs Declaration submitted"
    And the declaration status should be REJECTED
    And I should see the following errors
    | NotificationError(CDS12050,List(ErrorPointer(42A,None,None), ErrorPointer(67A,None,None), ErrorPointer(68A,Some(1),None), ErrorPointer(70A,None,Some(166)))) |
