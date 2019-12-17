@wip
Feature: Review all submitted declarations and provide link to add a new declaration

  Background:
    Given the mongo database is empty
    And our application is registered with the DEC-API
    And I am signed in as a registered user

  Scenario: User has not yet submitted any declarations
    When I navigate to the Your Import Declarations page
    Then I should see a message telling me that 'No declarations to display.'
    And I should see a link 'Make a Declaration'

