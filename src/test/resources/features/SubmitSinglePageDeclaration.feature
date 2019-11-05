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
      | Field Name                                                            | Value            |
      | 1.1 Declaration Type                                                  | DT               |
      | 1.2 Additional Declaration Type                                       | A                |
      | 1.6 Goods Item Number                                                 | 17               |
      | 1.9 Total Number Of Items                                             | 42               |
      | 1.10 Requested Procedure Code                                         | 66               |
      | 1.10 Previous Procedure Code                                          | 99               |
      | 1.11 Additional Procedure Code (000 or C07)                           | C07              |
      | 2.1 Previous Document Category                                        | Y                |
      | 2.1 Previous Document Type                                            | DCR              |
      | 2.1 Previous Document Reference                                       | 9GB201909014000  |
      | 2.1 Previous Document Goods Item Identifier                           | 1                |
      | 2.2 Additional Information Code                                       | 00500            |
      | 2.2 Additional Information Description                                | IMPORTER         |
      | 2.3 Additional Document Category Code                                 | N                |
      | 2.3 Additional Document Type Code                                     | 935              |
      | 2.3 Additional Document Identifier (include TSP authorisation number) | 12345/30.09.2019 |
      | 2.3 Additional Document Status                                        | AC               |
      | 2.3 Additional Document Status Reason                                 | DocumentName     |
      | 2.5 LRN                                                               | Test1234         |
      | 2.6 Deferred Payment ID                                               | 1909241          |
      | 2.6 Deferred Payment Category                                         | 1                |
      | 2.6 Deferred Payment Type                                             | DAN              |
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

  @wip
  Scenario: Section 3 answers are mapped to the correct XML elements
    Given I am signed in as a registered user
    And the Single Page Declaration feature is enabled
    When I navigate to the Simple Declaration page
    And I enter the following data
      | Field Name                             | Value                   |
      | 3.1 Exporter - Name                    | Transport du Tinfoil    |
      | 3.1 Exporter - Street and Number       | 1 Rue Aluminum          |
      | 3.1 Exporter - City                    | Metalville              |
      | 3.1 Exporter - Country                 | FR                      |
      | 3.1 Exporter - Postcode                | 07030                   |
      | 3.2 Exporter - EORI                    | FR12345678              |
      | 3.15 Importer - Name                   | Foil Solutions          |
      | 3.15 Importer - Street and Number      | Aluminium Way           |
      | 3.15 Importer - City                   | Metalton                |
      | 3.15 Importer - Country                | UK                      |
      | 3.15 Importer - Postcode               | ME7 4LL                 |
      | 3.16 Importer - EORI                   | GB87654321              |
      | 3.18 Declarant - EORI                  | GB15263748              |
      | 3.24 Seller - Name                     | Tinfoil Sans Frontieres |
      | 3.24 Seller - Street and Number        | 123 les Champs Insulees |
      | 3.24 Seller - City                     | Troyes                  |
      | 3.24 Seller - Country                  | FR                      |
      | 3.24 Seller - Postcode                 | 01414                   |
      | 3.24 Seller - Phone number             | 003344556677            |
      | 3.25 Seller - EORI                     | FR84736251              |
      | 3.26 Buyer - Name                      | Tinfoil R Us            |
      | 3.26 Buyer - Street and Number         | 12 Alcan Boulevard      |
      | 3.26 Buyer - City                      | Sheffield               |
      | 3.26 Buyer - Country                   | UK                      |
      | 3.26 Buyer - Postcode                  | S1 1VA                  |
      | 3.26 Buyer - Phone number              | 00441234567890          |
      | 3.27 Buyer - EORI                      | GB45362718              |
      | 3.39 Authorisation holder - identifier | GB62518473              |
      | 3.39 Authorisation holder - type code  | OK4U                    |
      | 3.40 VAT Number (or TSPVAT)            | 99887766                |
      | 3.40 Role Code                         | VAT                     |
    And I click on Submit
    Then I should see submitted page with the following response details for valid data
      | Status |
      | 202    |
    And the submitted XML should include a Declaration with the following data elements
      | Element      | Value      |
      | Declarant/ID | GB15263748 |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following Consignor
      | Element             | Value                |
      | Name                | Transport du Tinfoil |
      | Address/Line        | 1 Rue Aluminum       |
      | Address/CityName    | Metalville           |
      | Address/CountryCode | FR                   |
      | Address/PostcodeID  | 07030                |
      | ID                  | FR12345678           |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following Importer
      | Element             | Value          |
      | Name                | Foil Solutions |
      | Address/Line        | Aluminium Way  |
      | Address/CityName    | Metalton       |
      | Address/CountryCode | UK             |
      | Address/PostcodeID  | ME7 4LL        |
      | ID                  | GB87654321     |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following Seller
      | Element                  | Value                   |
      | Name                     | Tinfoil Sans Frontieres |
      | Address/Line             | 123 les Champs Insulees |
      | Address/CityName         | Troyes                  |
      | Address/CountryCode      | FR                      |
      | Address/PostcodeID       | 01414                   |
      | Contact/Communication/ID | 003344556677            |
      | ID                       | FR84736251              |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following Buyer
      | Element                  | Value              |
      | Name                     | Tinfoil R Us       |
      | Address/Line             | 12 Alcan Boulevard |
      | Address/CityName         | Sheffield          |
      | Address/CountryCode      | UK                 |
      | Address/PostcodeID       | S1 1VA             |
      | Contact/Communication/ID | 00441234567890     |
      | ID                       | GB45362718         |
    And the submitted XML should include a Declaration with the following AuthorisationHolder
      | Element      | Value      |
      | ID           | GB62518473 |
      | CategoryCode | OK4U       |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following DomesticDutyTaxParty
      | Element  | Value    |
      | ID       | 99887766 |
      | RoleCode | VAT      |

  Scenario: Section 1 default / auto-populated values
    Given I am signed in as a registered user
    And the Single Page Declaration feature is enabled
    When I navigate to the Simple Declaration page
    And I enter the following data
      | Field Name                                   | Value |
      | 1.11 Additional Procedure Code (000 or C07)  | C07   |
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
      | Declaration/GoodsShipment/GovernmentAgencyGoodsItem/PreviousDocument/CategoryCode              | Y                |
      | Declaration/GoodsShipment/GovernmentAgencyGoodsItem/PreviousDocument/TypeCode                  | DCR              |
      | Declaration/GoodsShipment/GovernmentAgencyGoodsItem/PreviousDocument/ID                        | 9GB201909014000  |
      | Declaration/GoodsShipment/GovernmentAgencyGoodsItem/PreviousDocument/LineNumeric               | 1                |
      | Declaration/GoodsShipment/GovernmentAgencyGoodsItem/AdditionalInformation/StatementCode        | 00500            |
      | Declaration/GoodsShipment/GovernmentAgencyGoodsItem/AdditionalInformation/StatementDescription | IMPORTER         |
      | Declaration/GoodsShipment/GovernmentAgencyGoodsItem/AdditionalDocument/CategoryCode            | N                |
      | Declaration/GoodsShipment/GovernmentAgencyGoodsItem/AdditionalDocument/TypeCode                | 935              |
      | Declaration/GoodsShipment/GovernmentAgencyGoodsItem/AdditionalDocument/ID                      | 12345/30.09.2019 |
      | Declaration/GoodsShipment/GovernmentAgencyGoodsItem/AdditionalDocument/LPCOExemptionCode       | AC               |
      | Declaration/GoodsShipment/GovernmentAgencyGoodsItem/AdditionalDocument/Name                    | DocumentName     |
      | Declaration/FunctionalReferenceID                                                              | Test1234         |
      | Declaration/AdditionalDocument/ID                                                              | 1909241          |
      | Declaration/AdditionalDocument/CategoryCode                                                    | 1                |
      | Declaration/AdditionalDocument/TypeCode                                                        | DAN              |
