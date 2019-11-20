@acceptance
Feature: Submit import declarations to the declarations API via the single page form

  Background:
    Given the mongo database is empty
    And our application is registered with the DEC-API
    And I am signed in as a registered user
    And the Single Page Declaration feature is enabled
  @zap
  Scenario: Sections 1 answers are mapped to the correct XML elements
    When I navigate to the Simple Declaration page
    And I enter the following data
      | Field Name                                                              | Value             |
      | 1.1 Declaration Type                                                    | DT                |
      | 1.2 Additional Declaration Type                                         | A                 |
      | 1.6 Goods Item Number                                                   | 17                |
      | 1.9 Total Number Of Items                                               | 42                |
      | 1.10 Requested Procedure Code                                           | 66                |
      | 1.10 Previous Procedure Code                                            | 99                |
      | 1.11 Additional Procedure Code (000 or C07)                             | C07               |
    And I click on Submit
    Then I should see submitted page with the following response details for valid data
      | Status |
      | 202    |
    And the submitted XML should include a Declaration with the following data elements
      | Element               | Value    |
      | TypeCode              | DTA      |
      | GoodsItemQuantity     | 42       |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following data elements
      | Element                          | Value |
      | SequenceNumeric                  | 17    |
      | GovernmentProcedure/CurrentCode  | 66    |
      | GovernmentProcedure/CurrentCode  | C07   |
      | GovernmentProcedure/PreviousCode | 99    |

  Scenario: Sections 2 Previous document answers are mapped to the correct XML elements at Item level
    When I navigate to the Simple Declaration page
    And I enter the following data
      | Field Name                                                               | Value             |
      | 2.1 Previous Document Category 1                                         | Y                 |
      | 2.1 Previous Document Type 1                                             | DCR               |
      | 2.1 Previous Document Reference 1                                        | 1                 |
      | 2.1 Previous Document Goods Item Identifier 1                            | 9GB201909014000   |
      | 2.1 Previous Document Category 2                                         | Y                 |
      | 2.1 Previous Document Type 2                                             | CLE               |
      | 2.1 Previous Document Reference 2                                        | 1                 |
      | 2.1 Previous Document Goods Item Identifier 2                            | 20191101          |
      | 2.1 Previous Document Category 3                                         | Z                 |
      | 2.1 Previous Document Type 3                                             | ZZZ               |
      | 2.1 Previous Document Reference 3                                        | 1                 |
      | 2.1 Previous Document Goods Item Identifier 3                            | 20191103          |
      | 2.1 Previous Document Category 4                                         | Z                 |
      | 2.1 Previous Document Type 4                                             | 235               |
      | 2.1 Previous Document Reference 4                                        | 1                 |
      | 2.1 Previous Document Goods Item Identifier 4                            | 9GB201909014002   |
      | 2.1 Previous Document Category 5                                         | Z                 |
      | 2.1 Previous Document Type 5                                             | ZZZ               |
      | 2.1 Previous Document Reference 5                                        | 1                 |
      | 2.1 Previous Document Goods Item Identifier 5                            | 9GB201909014003   |
      | 2.1 Previous Document Category 6                                         | Z                 |
      | 2.1 Previous Document Type 6                                             | 270               |
      | 2.1 Previous Document Reference 6                                        | 1                 |
      | 2.1 Previous Document Goods Item Identifier 6                            | 9GB201909014004   |
    And I click on Submit
    Then I should see submitted page with the following response details for valid data
      | Status |
      | 202    |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following PreviousDocument
      | Element      | Value           |
      | CategoryCode | Y               |
      | TypeCode     | DCR             |
      | ID           | 9GB201909014000 |
      | LineNumeric  | 1               |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following PreviousDocument
      | Element      | Value           |
      | CategoryCode | Y               |
      | TypeCode     | CLE             |
      | ID           | 20191101        |
      | LineNumeric  | 1               |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following PreviousDocument
      | Element      | Value           |
      | CategoryCode | Z               |
      | TypeCode     | ZZZ             |
      | ID           | 20191103        |
      | LineNumeric  | 1               |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following PreviousDocument
      | Element      | Value           |
      | CategoryCode | Z               |
      | TypeCode     | 235             |
      | ID           | 9GB201909014002 |
      | LineNumeric  | 1               |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following PreviousDocument
      | Element      | Value           |
      | CategoryCode | Z               |
      | TypeCode     | ZZZ             |
      | ID           | 9GB201909014003 |
      | LineNumeric  | 1               |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following PreviousDocument
      | Element      | Value           |
      | CategoryCode | Z               |
      | TypeCode     | 270             |
      | ID           | 9GB201909014004 |
      | LineNumeric  | 1               |

  Scenario: Sections 2 Previous document answers are mapped to the correct XML elements at Header level
    Given PENDING
    When I navigate to the Simple Declaration page
    And I enter the following data
      | Field Name                                                               | Value             |
      | 2.1 Header Previous Document Category 1                                  | Y                 |
      | 2.1 Header Previous Document Type 1                                      | DCR               |
      | 2.1 Header Previous Document Reference 1                                 | 1                 |
      | 2.1 Header Previous Document Goods Item Identifier 1                     | 9GB201909014001   |
      | 2.1 Header Previous Document Category 2                                  | Y                 |
      | 2.1 Header Previous Document Type 2                                      | CLE               |
      | 2.1 Header Previous Document Reference 2                                 | 1                 |
      | 2.1 Header Previous Document Goods Item Identifier 2                     | 20191102          |
      | 2.1 Header Previous Document Category 3                                  | Z                 |
      | 2.1 Header Previous Document Type 3                                      | ZZZ               |
      | 2.1 Header Previous Document Reference 3                                 | 1                 |
      | 2.1 Header Previous Document Goods Item Identifier 3                     | 20191104          |
      | 2.1 Header Previous Document Category 4                                  | Z                 |
      | 2.1 Header Previous Document Type 4                                      | 235               |
      | 2.1 Header Previous Document Reference 4                                 | 1                 |
      | 2.1 Header Previous Document Goods Item Identifier 4                     | 9GB201909014003   |
    And I click on Submit
    Then I should see submitted page with the following response details for valid data
      | Status |
      | 202    |
    And the submitted XML should include a GoodsShipment with the following PreviousDocument
      | Element      | Value           |
      | CategoryCode | Y               |
      | TypeCode     | DCR             |
      | ID           | 9GB201909014001 |
      | LineNumeric  | 1               |
    And the submitted XML should include a GoodsShipment with the following PreviousDocument
      | Element      | Value           |
      | CategoryCode | Y               |
      | TypeCode     | CLE             |
      | ID           | 20191102        |
      | LineNumeric  | 1               |
    And the submitted XML should include a GoodsShipment with the following PreviousDocument
      | Element      | Value           |
      | CategoryCode | Z               |
      | TypeCode     | ZZZ             |
      | ID           | 20191104        |
      | LineNumeric  | 1               |
    And the submitted XML should include a GoodsShipment with the following PreviousDocument
      | Element      | Value           |
      | CategoryCode | Z               |
      | TypeCode     | 235             |
      | ID           | 9GB201909014003 |
      | LineNumeric  | 1               |

  Scenario: Sections 2 Deferred payment answers are mapped to the correct XML elements
    When I navigate to the Simple Declaration page
    And I enter the following data
      | Field Name                                                              | Value             |
      | 2.6 Deferred Payment ID 1                                               | 1909241           |
      | 2.6 Deferred Payment Category 1                                         | 1                 |
      | 2.6 Deferred Payment Type 1                                             | DAN               |
      | 2.6 Deferred Payment ID 2                                               | 1909242           |
      | 2.6 Deferred Payment Category 2                                         | 1                 |
      | 2.6 Deferred Payment Type 2                                             | DAN               |
    And I click on Submit
    Then I should see submitted page with the following response details for valid data
      | Status |
      | 202    |
    And the submitted XML should include a Declaration with the following AdditionalDocument
      | Element               | Value   |
      | ID                    | 1909241 |
      | CategoryCode          | 1       |
      | TypeCode              | DAN     |
    And the submitted XML should include a Declaration with the following AdditionalDocument
      | Element               | Value   |
      | ID                    | 1909242 |
      | CategoryCode          | 1       |
      | TypeCode              | DAN     |

  Scenario: Sections 2 Additional Information and LRN answers are mapped to the correct XML elements
    When I navigate to the Simple Declaration page
    And I enter the following data
      | Field Name                                                              | Value             |
      | 2.2 Header Additional Information Code                                  | TSP01             |
      | 2.2 Header Additional Information Description                           | TSP               |
      | 2.2 Item Additional Information Code 1                                  | 00500             |
      | 2.2 Item Additional Information Description 1                           | IMPORTER          |
      | 2.2 Item Additional Information Code 2                                  | 00501             |
      | 2.2 Item Additional Information Description 2                           | EXPORTER          |
      | 2.2 Item Additional Information Code 3                                  | 00502             |
      | 2.2 Item Additional Information Description 3                           | HOTEL PORTER      |
      | 2.2 Item Additional Information Code 4                                  | 00503             |
      | 2.2 Item Additional Information Description 4                           | COLE PORTER       |
      | 2.2 Item Additional Information Code 5                                  | 00504             |
      | 2.2 Item Additional Information Description 5                           | PINT OF PORTER    |
      | 2.2 Item Additional Information Code 6                                  | 00505             |
      | 2.2 Item Additional Information Description 6                           | PRET A PORTER     |
      | 2.5 LRN                                                                 | Test1234          |
    And I click on Submit
    Then I should see submitted page with the following response details for valid data
      | Status |
      | 202    |
    And the submitted XML should include a Declaration with the following data elements
      | Element               | Value    |
      | FunctionalReferenceID | Test1234 |
    And the submitted XML should include a Declaration with the following AdditionalInformation
      | Element              | Value    |
      | StatementCode        | TSP01    |
      | StatementDescription | TSP      |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following AdditionalInformation
      | Element              | Value    |
      | StatementCode        | 00500    |
      | StatementDescription | IMPORTER |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following AdditionalInformation
      | Element              | Value    |
      | StatementCode        | 00501    |
      | StatementDescription | EXPORTER |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following AdditionalInformation
      | Element              | Value        |
      | StatementCode        | 00502        |
      | StatementDescription | HOTEL PORTER |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following AdditionalInformation
      | Element              | Value       |
      | StatementCode        | 00503       |
      | StatementDescription | COLE PORTER |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following AdditionalInformation
      | Element              | Value          |
      | StatementCode        | 00504          |
      | StatementDescription | PINT OF PORTER |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following AdditionalInformation
      | Element              | Value         |
      | StatementCode        | 00505         |
      | StatementDescription | PRET A PORTER |

  Scenario: Sections 2 Additional Document answers are mapped to the correct XML elements
    When I navigate to the Simple Declaration page
    And I enter the following data
      | Field Name                                                              | Value             |
      | 2.3 Additional Document Category Code 1                                 | N                 |
      | 2.3 Additional Document Type Code 1                                     | 935               |
      | 2.3 Additional Document Identifier (include TSP authorisation number) 1 | 12345/30.09.2019  |
      | 2.3 Additional Document Status 1                                        | AC                |
      | 2.3 Additional Document Status Reason 1                                 | DocumentName1     |
      | 2.3 Additional Document Category Code 2                                 | C                 |
      | 2.3 Additional Document Type Code 2                                     | 514               |
      | 2.3 Additional Document Identifier (include TSP authorisation number) 2 | GBEIR201909014000 |
      | 2.3 Additional Document Status 2                                        |                   |
      | 2.3 Additional Document Status Reason 2                                 |                   |
      | 2.3 Additional Document Category Code 3                                 | C                 |
      | 2.3 Additional Document Type Code 3                                     | 506               |
      | 2.3 Additional Document Identifier (include TSP authorisation number) 3 | GBDPO1909241      |
      | 2.3 Additional Document Status 3                                        |                   |
      | 2.3 Additional Document Status Reason 3                                 |                   |
      | 2.3 Additional Document Category Code 4                                 | N                 |
      | 2.3 Additional Document Type Code 4                                     | 935               |
      | 2.3 Additional Document Identifier (include TSP authorisation number) 4 | 12345/30.07.2019  |
      | 2.3 Additional Document Status 4                                        | AC                |
      | 2.3 Additional Document Status Reason 4                                 |                   |
      | 2.3 Additional Document Category Code 5                                 | N                 |
      | 2.3 Additional Document Type Code 5                                     | 935               |
      | 2.3 Additional Document Identifier (include TSP authorisation number) 5 | 12345/30.08.2019  |
      | 2.3 Additional Document Status 5                                        | AC                |
      | 2.3 Additional Document Status Reason 5                                 |                   |
      | 2.3 Additional Document Category Code 6                                 | N                 |
      | 2.3 Additional Document Type Code 6                                     | 935               |
      | 2.3 Additional Document Identifier (include TSP authorisation number) 6 | 12345/30.09.2019  |
      | 2.3 Additional Document Status 6                                        | AC                |
      | 2.3 Additional Document Status Reason 6                                 |                   |
    And I click on Submit
    Then I should see submitted page with the following response details for valid data
      | Status |
      | 202    |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following AdditionalDocument
      | Element                 | Value            |
      | CategoryCode            | N                |
      | TypeCode                | 935              |
      | ID                      | 12345/30.09.2019 |
      | LPCOExemptionCode       | AC               |
      | Name                    | DocumentName1    |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following AdditionalDocument
      | Element                 | Value             |
      | CategoryCode            | C                 |
      | TypeCode                | 514               |
      | ID                      | GBEIR201909014000 |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following AdditionalDocument
      | Element                 | Value         |
      | CategoryCode            | C             |
      | TypeCode                | 506           |
      | ID                      | GBDPO1909241  |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following AdditionalDocument
      | Element                 | Value            |
      | CategoryCode            | N                |
      | TypeCode                | 935              |
      | ID                      | 12345/30.07.2019 |
      | LPCOExemptionCode       | AC               |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following AdditionalDocument
      | Element                 | Value            |
      | CategoryCode            | N                |
      | TypeCode                | 935              |
      | ID                      | 12345/30.08.2019 |
      | LPCOExemptionCode       | AC               |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following AdditionalDocument
      | Element                 | Value            |
      | CategoryCode            | N                |
      | TypeCode                | 935              |
      | ID                      | 12345/30.09.2019 |
      | LPCOExemptionCode       | AC               |

  Scenario: Section 3 Exporter fields are mapped to the correct XML elements
    When I navigate to the Simple Declaration page
    And I enter the following data
      | Field Name                             | Value                   |
      | 3.1 Exporter - Name                    | Transport du Tinfoil    |
      | 3.1 Exporter - Street and Number       | 1 Rue Aluminum          |
      | 3.1 Exporter - City                    | Metalville              |
      | 3.1 Exporter - Country Code            | FR                      |
      | 3.1 Exporter - Postcode                | 07030                   |
      | 3.2 Exporter - EORI                    | FR12345678              |
    And I click on Submit
    Then I should see submitted page with the following response details for valid data
      | Status |
      | 202    |
    And the submitted XML should include a Declaration with the following Exporter
      | Element             | Value                |
      | Name                | Transport du Tinfoil |
      | Address/Line        | 1 Rue Aluminum       |
      | Address/CityName    | Metalville           |
      | Address/CountryCode | FR                   |
      | Address/PostcodeID  | 07030                |
      | ID                  | FR12345678           |

  Scenario: Section 3 Declarant fields are mapped to the correct XML elements
    When I navigate to the Simple Declaration page
    And I enter the following data
      | Field Name                             | Value                   |
      | 3.18 Declarant - EORI                  | GB15263748              |
    And I click on Submit
    Then I should see submitted page with the following response details for valid data
      | Status |
      | 202    |
    And the submitted XML should include a Declaration with the following data elements
      | Element      | Value      |
      | Declarant/ID | GB15263748 |

  Scenario: Section 3 Importer fields are mapped to the correct XML elements
    When I navigate to the Simple Declaration page
    And I enter the following data
      | Field Name                             | Value                   |
      | 3.15 Importer - Name                   | Foil Solutions          |
      | 3.15 Importer - Street and Number      | Aluminium Way           |
      | 3.15 Importer - City                   | Metalton                |
      | 3.15 Importer - Country Code           | UK                      |
      | 3.15 Importer - Postcode               | ME7 4LL                 |
      | 3.16 Importer - EORI                   | GB87654321              |
    And I click on Submit
    Then I should see submitted page with the following response details for valid data
      | Status |
      | 202    |
    And the submitted XML should include a GoodsShipment with the following Importer
      | Element             | Value          |
      | Name                | Foil Solutions |
      | Address/Line        | Aluminium Way  |
      | Address/CityName    | Metalton       |
      | Address/CountryCode | UK             |
      | Address/PostcodeID  | ME7 4LL        |
      | ID                  | GB87654321     |

  Scenario: Section 3 Seller fields are mapped to the correct XML elements
    When I navigate to the Simple Declaration page
    And I enter the following data
      | Field Name                             | Value                   |
      | 3.24 Seller - Name                     | Tinfoil Sans Frontieres |
      | 3.24 Seller - Street and Number        | 123 les Champs Insulees |
      | 3.24 Seller - City                     | Troyes                  |
      | 3.24 Seller - Country Code             | FR                      |
      | 3.24 Seller - Postcode                 | 01414                   |
      | 3.24 Seller - Phone Number             | 003344556677            |
      | 3.25 Seller - EORI                     | FR84736251              |
    And I click on Submit
    Then I should see submitted page with the following response details for valid data
      | Status |
      | 202    |
    And the submitted XML should include a GoodsShipment with the following Seller
      | Element                  | Value                   |
      | Name                     | Tinfoil Sans Frontieres |
      | Address/Line             | 123 les Champs Insulees |
      | Address/CityName         | Troyes                  |
      | Address/CountryCode      | FR                      |
      | Address/PostcodeID       | 01414                   |
      | Communication/ID         | 003344556677            |
      | ID                       | FR84736251              |

  Scenario: Section 3 Buyer fields are mapped to the correct XML elements
    When I navigate to the Simple Declaration page
    And I enter the following data
      | Field Name                             | Value                   |
      | 3.26 Buyer - Name                      | Tinfoil R Us            |
      | 3.26 Buyer - Street and Number         | 12 Alcan Boulevard      |
      | 3.26 Buyer - City                      | Sheffield               |
      | 3.26 Buyer - Country Code              | UK                      |
      | 3.26 Buyer - Postcode                  | S1 1VA                  |
      | 3.26 Buyer - Phone Number              | 00441234567890          |
      | 3.27 Buyer - EORI                      | GB45362718              |
    And I click on Submit
    Then I should see submitted page with the following response details for valid data
      | Status |
      | 202    |
    And the submitted XML should include a GoodsShipment with the following Buyer
      | Element                  | Value              |
      | Name                     | Tinfoil R Us       |
      | Address/Line             | 12 Alcan Boulevard |
      | Address/CityName         | Sheffield          |
      | Address/CountryCode      | UK                 |
      | Address/PostcodeID       | S1 1VA             |
      | Communication/ID         | 00441234567890     |
      | ID                       | GB45362718         |

  Scenario: Section 3 miscellaneous fields are mapped to the correct XML elements
    When I navigate to the Simple Declaration page
    And I enter the following data
      | Field Name                               | Value                   |
      | 3.39 Authorisation holder - identifier 1 | GB62518473              |
      | 3.39 Authorisation holder - type code 1  | OK4U                    |
      | 3.39 Authorisation holder - identifier 2 | GB98229822              |
      | 3.39 Authorisation holder - type code 2  | YAY1                    |
      | 3.40 VAT Number (or TSPVAT) 1            | 99887766                |
      | 3.40 Role Code 1                         | VAT                     |
      | 3.40 VAT Number (or TSPVAT) 2            | 99997777                |
      | 3.40 Role Code 2                         | RAT                     |
    And I click on Submit
    Then I should see submitted page with the following response details for valid data
      | Status |
      | 202    |
    And the submitted XML should include a Declaration with the following AuthorisationHolder
      | Element      | Value      |
      | ID           | GB62518473 |
      | CategoryCode | OK4U       |
    And the submitted XML should include a Declaration with the following AuthorisationHolder
      | Element      | Value      |
      | ID           | GB98229822 |
      | CategoryCode | YAY1       |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following DomesticDutyTaxParty
      | Element  | Value    |
      | ID       | 99887766 |
      | RoleCode | VAT      |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following DomesticDutyTaxParty
      | Element  | Value    |
      | ID       | 99997777 |
      | RoleCode | RAT      |

  Scenario: Section 4 answers are mapped to the correct XML elements
    When I navigate to the Simple Declaration page
    And I enter the following data
      | Field Name                       | Value    |
      | 4.1 INCOTERM code                | CFR      |
      | 4.1 UN/LOCODE code               | GBDVR    |
      | 4.1 Country code + Location Name |          |
      | 4.8 Method of Payment            | E        |
      | 4.13 Valuation Indicators        | 0000     |
      | 4.14 Item Price/Amount           | 90500000 |
      | 4.14 Item Price/Currency Unit    | GBP      |
      | 4.15 Exchange Rate               | 1.25     |
      | 4.16 Valuation Method            | 1        |
      | 4.17 Preference                  | 100      |
    And I click on Submit
    And the submitted XML should include a Declaration with the following TradeTerms
      | Element       | Value |
      | ConditionCode | CFR   |
      | LocationID    | GBDVR |
    And the submitted XML should include a Declaration with the following CurrencyExchange
      | Element     | Value |
      | RateNumeric | 1.25  |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following Payment
      | Element    | Value |
      | MethodCode | E     |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following ValuationAdjustment
      | Element      | Value |
      | AdditionCode | 0000  |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following InvoiceLine
      | Element          | Value    |
      | ItemChargeAmount | 90500000 |
    And the currencyID attribute of node ItemChargeAmount should be GBP
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following CustomsValuation
      | Element          | Value    |
      | MethodCode       | 1        |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following DutyTaxFee
      | Element          | Value    |
      | DutyRegimeCode   | 100      |

