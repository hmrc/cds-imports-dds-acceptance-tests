@acceptance @zap
Feature: Submit import declarations to the declarations API via the single page form

  Background:
    Given the mongo database is empty
    And our application is registered with the DEC-API

  Scenario: Sections 1 and 2 answers are mapped to the correct XML elements
    Given I am signed in as a registered user
    And the Single Page Declaration feature is enabled
    When I navigate to the Simple Declaration page
    And I enter the following data
      | Field Name                                   | Value            |
      | 1.1 Declaration Type                         | DT               |
      | 1.2 Additional Declaration Type              | A                |
      | 1.6 Goods Item Number                        | 17               |
      | 1.9 Total Number Of Items                    | 42               |
      | 1.10 Requested Procedure Code                | 66               |
      | 1.10 Previous Procedure Code                 | 99               |
      | 1.11 Additional Procedure Code (000 or C07)  | C07              |
      | 2.1 Document Category                        | Y                |
      | 2.1 Previous Document Type                   | DCR              |
      | 2.1 Previous Document Reference              | 9GB201909014000  |
      | 2.1 Goods Item Identifier                    | 1                |
      | 2.2 Code                                     | 00500            |
      | 2.2 Description                              | IMPORTER         |
      | 2.3 Document Category Code                   | N                |
      | 2.3 Document Type Code                       | 935              |
      | 2.3 Document Identifier                      | 12345/30.09.2019 |
      | 2.3 Document Status                          | AC               |
      | 2.3 Document Status Reason                   | DocumentName     |
      | 2.5 LRN                                      | Test1234         |
      | 2.6 Deferred Payment ID                      | 1909241          |
      | 2.6 Deferred Payment Category                | 1                |
      | 2.6 Deferred Payment Type                    | DAN              |
    And I click on Submit
    Then I should see submitted page with the following response details for valid data
      | Status |
      | 202    |
    And the submitted XML should include a Declaration with the following data elements
      | Element               | Value    |
      | FunctionalReferenceID | Test1234 |
      | TypeCode              | DTA      |
      | GoodsItemQuantity     | 42       |
    And the submitted XML should include a Declaration with the following AdditionalDocument
      | Element               | Value   |
      | ID                    | 1909241 |
      | CategoryCode          | 1       |
      | TypeCode              | DAN     |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following data elements
      | Element                          | Value |
      | SequenceNumeric                  | 17    |
      | GovernmentProcedure/CurrentCode  | 66    |
      | GovernmentProcedure/CurrentCode  | C07   |
      | GovernmentProcedure/PreviousCode | 99    |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following PreviousDocument
      | Element      | Value           |
      | CategoryCode | Y               |
      | TypeCode     | DCR             |
      | ID           | 9GB201909014000 |
      | LineNumeric  | 1               |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following AdditionalInformation
      | Element              | Value    |
      | StatementCode        | 00500    |
      | StatementDescription | IMPORTER |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following AdditionalDocument
      | Element                 | Value            |
      | CategoryCode            | N                |
      | TypeCode                | 935              |
      | ID                      | 12345/30.09.2019 |
      | LPCOExemptionCode       | AC               |
      | Name                    | DocumentName     |

  Scenario: Section 1 default / auto-populated values
    Given I am signed in as a registered user
    And the Single Page Declaration feature is enabled
    When I navigate to the Simple Declaration page
    And I enter the following data
      | Field Name                                   | Value |
      | 1.11 Additional Procedure Code (000 or C07)  | C07   |
      | 2.1 Document Category                        | Y                |
      | 2.1 Previous Document Type                   | DCR              |
      | 2.1 Previous Document Reference              | 9GB201909014000  |
      | 2.1 Goods Item Identifier                    | 1                |
      | 2.2 Code                                     | 00500            |
      | 2.2 Description                              | IMPORTER         |
      | 2.3 Document Category Code                   | N                |
      | 2.3 Document Type Code                       | 935              |
      | 2.3 Document Identifier                      | 12345/30.09.2019 |
      | 2.3 Document Status                          | AC               |
      | 2.3 Document Status Reason                   | DocumentName     |
      | 2.5 LRN                                      | Test1234         |
      | 2.6 Deferred Payment ID                      | 1909241          |
      | 2.6 Deferred Payment Category                | 1                |
      | 2.6 Deferred Payment Type                    | DAN              |
    And I click on Submit
    Then I should see submitted page with the following response details for valid data
      | Status |
      | 202    |
    And the submitted XML should include the following data elements
      | Path                                                                                           | Value            |
      | Declaration/TypeCode                                                                           | IMZ              |
      | Declaration/GoodsItemQuantity                                                                  | 1                |
      | Declaration/GoodsShipment/GovernmentAgencyGoodsItem/SequenceNumeric                            | 1                |
      | Declaration/GoodsShipment/GovernmentAgencyGoodsItem/GovernmentProcedure/CurrentCode            | 40               |
      | Declaration/GoodsShipment/GovernmentAgencyGoodsItem/GovernmentProcedure/CurrentCode            | C07              |
      | Declaration/GoodsShipment/GovernmentAgencyGoodsItem/GovernmentProcedure/PreviousCode           | 00               |

