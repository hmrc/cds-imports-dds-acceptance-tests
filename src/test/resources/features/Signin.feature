@acceptance @smoke @zap
  Feature: Import sign in feature

    Scenario: Sign in as a registered user
      Given I am signed in as a registered user
      Then I should see the heading "Make an import declaration"