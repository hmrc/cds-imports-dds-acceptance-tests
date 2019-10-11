@acceptance @smoke
  Feature: Hello World

    Scenario: Hello World page is visible when feature is enabled
      Given the Hello World feature is enabled
      When I navigate to the Hello World page
      Then I should see the heading "Hello from cds-imports-dds-frontend !"

    Scenario: Hello World page is visible when feature is disabled
      Given the Hello World feature is disabled
      When I navigate to the Hello World page
      Then I should see the heading "This page can’t be found"
