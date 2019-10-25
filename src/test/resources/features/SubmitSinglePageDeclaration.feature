@acceptance
Feature: Submit import declarations to the declarations API via the single page form

  Background:
    Given the mongo database is empty
    And our application is registered with the DEC-API

  Scenario: Section 1 answers are mapped to the correct XML elements
    Given I am signed in as a registered user
    And the Single Page Declaration feature is enabled
    When I navigate to the Simple Declaration page
    And I enter the following data
      | Field Name                                   | Value |
      | 1.1. Declaration Type                        | DT    |
      | 1.2. Additional Declaration Type             | A     |
      | 1.6. Goods Item Number                       | 17    |
      | 1.9. Total Number Of Items                   | 42    |
      | 1.10. Requested Procedure Code               | 66    |
      | 1.10. Previous Procedure Code                | 99    |
      | 1.11. Additional Procedure Code (000 or C07) | C07   |
    And I click on Submit
    Then I should see submitted page with the following response details for valid data
      | Status |
      | 202    |
    And the submitted XML should include the following data elements
      | Path                                                                                    | Value |
      | Declaration/TypeCode                                                                    | DTA   |
      | Declaration/GoodsItemQuantity                                                           | 42    |
      | Declaration/GoodsShipment/GovernmentAgencyGoodsItem/SequenceNumeric                     | 17    |
      | Declaration/GoodsShipment/GovernmentAgencyGoodsItem/GovernmentProcedure/CurrentCode     | 66    |
      | Declaration/GoodsShipment/GovernmentAgencyGoodsItem/GovernmentProcedure/CurrentCode     | C07   |
      | Declaration/GoodsShipment/GovernmentAgencyGoodsItem/GovernmentProcedure/PreviousCode    | 99    |

  Scenario: Section 1 default / auto-populated values
    Given I am signed in as a registered user
    And the Single Page Declaration feature is enabled
    When I navigate to the Simple Declaration page
    And I enter the following data
      | Field Name                                   | Value |
      | 1.11. Additional Procedure Code (000 or C07) | C07   |
    And I click on Submit
    Then I should see submitted page with the following response details for valid data
      | Status |
      | 202    |
    And the submitted XML should include the following data elements
      | Path                                                                                    | Value |
      | Declaration/TypeCode                                                                    | IMZ   |
      | Declaration/GoodsItemQuantity                                                           | 1     |
      | Declaration/GoodsShipment/GovernmentAgencyGoodsItem/SequenceNumeric                     | 1     |
      | Declaration/GoodsShipment/GovernmentAgencyGoodsItem/GovernmentProcedure/CurrentCode     | 40    |
      | Declaration/GoodsShipment/GovernmentAgencyGoodsItem/GovernmentProcedure/CurrentCode     | C07   |
      | Declaration/GoodsShipment/GovernmentAgencyGoodsItem/GovernmentProcedure/PreviousCode    | 00    |
