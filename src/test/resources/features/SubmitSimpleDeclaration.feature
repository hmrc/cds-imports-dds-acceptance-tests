@acceptance @wip
Feature: Submit import declarations to the declarations API

  Background:
    Given the mongo database is empty
    And our application is registered with the DEC-API

  Scenario: Section 1 answers are mapped to the correct XML elements
    Given I am signed in as a registered user
    When I navigate to the Simple Declaration page
    And I enter the following data
      | Field Name                             | Value |
      | Declaration Type                       | DT    |
      | Additional Declaration Type            | A     |
      | Goods Item Number                      | 17    |
      | Total Number Of Items                  | 42    |
      | Requested Procedure Code               | 66    |
      | Previous Procedure Code                | 99    |
      | Additional Procedure Code (000 or C07) | C07   |
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
      | Declaration/GoodsShipment/GovernmentAgencyGoodsItem/GovernmentProcedure/PreviousCode    | 99    |
#      | Declaration/GoodsShipment/GovernmentAgencyGoodsItem/GovernmentProcedure/CurrentCode(2)  | C07   |

  # TODO maybe just assert on field values on page load...
  Scenario: Section 1 default values
    Given I am signed in as a registered user
    When I navigate to the Simple Declaration page
    And I enter the following data
      | Field Name                             | Value |
      | Additional Procedure Code (000 or C07) | C07   |
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
      | Declaration/GoodsShipment/GovernmentAgencyGoodsItem/GovernmentProcedure/PreviousCode    | 00    |
