@acceptance
  Feature: Import sign in feature

    Scenario: Sign in as a registered user
      Given I am signed in as a registered user
      Then I should land on a temporary page