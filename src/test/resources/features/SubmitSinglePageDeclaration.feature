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
      | Field Name                                  | Value |
      | 1.1 Declaration Type                        | DT    |
      | 1.2 Additional Declaration Type             | A     |
      | 1.6 Goods Item Number                       | 17    |
      | 1.9 Total Number Of Items                   | 42    |
      | 1.10 Requested Procedure Code               | 66    |
      | 1.10 Previous Procedure Code                | 99    |
      | 1.11 Additional Procedure Code (000 or C07) | C07   |
    And I click on Submit
    Then I should see submitted page with the following response details for valid data
      | Status |
      | 202    |
    And the submitted XML should include a Declaration with the following data elements
      | Element           | Value |
      | TypeCode          | DTA   |
      | GoodsItemQuantity | 42    |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following data elements
      | Element                          | Value |
      | SequenceNumeric                  | 17    |
      | GovernmentProcedure/CurrentCode  | 66    |
      | GovernmentProcedure/CurrentCode  | C07   |
      | GovernmentProcedure/PreviousCode | 99    |

  Scenario: Sections 2 Previous document answers are mapped to the correct XML elements at Item level
    When I navigate to the Simple Declaration page
    And I enter the following previous document data at item level
      | categoryCode | typeCode | lineNumeric | id              |
      | Y            | DCR      | 1           | 9GB201909014000 |
      | Y            | CLE      | 1           | 20191101        |
      | Z            | ZZZ      | 1           | 20191103        |
      | Z            | 235      | 1           | 9GB201909014002 |
      | Z            | ZZZ      | 1           | 9GB201909014003 |
      | Z            | 270      | 1           | 9GB201909014004 |
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
      | Element      | Value    |
      | CategoryCode | Y        |
      | TypeCode     | CLE      |
      | ID           | 20191101 |
      | LineNumeric  | 1        |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following PreviousDocument
      | Element      | Value    |
      | CategoryCode | Z        |
      | TypeCode     | ZZZ      |
      | ID           | 20191103 |
      | LineNumeric  | 1        |
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
    When I navigate to the Simple Declaration page
    And I enter the following previous document data at header level
      | categoryCode | typeCode | lineNumeric | id              |
      | Y            | DCR      | 1           | 9GB201909014001 |
      | Y            | CLE      | 1           | 20191102        |
      | Z            | ZZZ      | 1           | 20191104        |
      | Z            | 235      | 1           | 9GB201909014003 |
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
      | Element      | Value    |
      | CategoryCode | Y        |
      | TypeCode     | CLE      |
      | ID           | 20191102 |
      | LineNumeric  | 1        |
    And the submitted XML should include a GoodsShipment with the following PreviousDocument
      | Element      | Value    |
      | CategoryCode | Z        |
      | TypeCode     | ZZZ      |
      | ID           | 20191104 |
      | LineNumeric  | 1        |
    And the submitted XML should include a GoodsShipment with the following PreviousDocument
      | Element      | Value           |
      | CategoryCode | Z               |
      | TypeCode     | 235             |
      | ID           | 9GB201909014003 |
      | LineNumeric  | 1               |

  Scenario: Sections 2 Deferred payment answers are mapped to the correct XML elements
    When I navigate to the Simple Declaration page
    And I enter the following data
      | Field Name                      | Value   |
      | 2.6 Deferred Payment ID 1       | 1909241 |
      | 2.6 Deferred Payment Category 1 | 1       |
      | 2.6 Deferred Payment Type 1     | DAN     |
      | 2.6 Deferred Payment ID 2       | 1909242 |
      | 2.6 Deferred Payment Category 2 | 1       |
      | 2.6 Deferred Payment Type 2     | DAN     |
    And I click on Submit
    Then I should see submitted page with the following response details for valid data
      | Status |
      | 202    |
    And the submitted XML should include a Declaration with the following AdditionalDocument
      | Element      | Value   |
      | ID           | 1909241 |
      | CategoryCode | 1       |
      | TypeCode     | DAN     |
    And the submitted XML should include a Declaration with the following AdditionalDocument
      | Element      | Value   |
      | ID           | 1909242 |
      | CategoryCode | 1       |
      | TypeCode     | DAN     |

  Scenario: Sections 2 Additional Information and LRN answers are mapped to the correct XML elements
    When I navigate to the Simple Declaration page
    And I enter the following data
      | Field Name                                    | Value          |
      | 2.2 Header Additional Information Code        | TSP01          |
      | 2.2 Header Additional Information Description | TSP            |
      | 2.2 Item Additional Information Code 1        | 00500          |
      | 2.2 Item Additional Information Description 1 | IMPORTER       |
      | 2.2 Item Additional Information Code 2        | 00501          |
      | 2.2 Item Additional Information Description 2 | EXPORTER       |
      | 2.2 Item Additional Information Code 3        | 00502          |
      | 2.2 Item Additional Information Description 3 | HOTEL PORTER   |
      | 2.2 Item Additional Information Code 4        | 00503          |
      | 2.2 Item Additional Information Description 4 | COLE PORTER    |
      | 2.2 Item Additional Information Code 5        | 00504          |
      | 2.2 Item Additional Information Description 5 | PINT OF PORTER |
      | 2.2 Item Additional Information Code 6        | 00505          |
      | 2.2 Item Additional Information Description 6 | PRET A PORTER  |
      | 2.5 LRN                                       | Test1234       |
    And I click on Submit
    Then I should see submitted page with the following response details for valid data
      | Status |
      | 202    |
    And the submitted XML should include a Declaration with the following data elements
      | Element               | Value    |
      | FunctionalReferenceID | Test1234 |
    And the submitted XML should include a Declaration with the following AdditionalInformation
      | Element              | Value |
      | StatementCode        | TSP01 |
      | StatementDescription | TSP   |
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
@wip
  Scenario: Sections 2 and 8.7 Additional Document answers are mapped to the correct XML elements
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
      | 8.7 Additional Document Category Code                                   | N                 |
      | 8.7 Additional Document Type Code                                       | 935               |
      | 8.7 Additional Document Identifier (include TSP authorisation number)   | 12345/30.09.2019  |
      | 8.7 Additional Document Status                                          | AC                |
      | 8.7 Additional Document Status Reason                                   |                   |
      | 8.7 Writing Off - Issuing Authority                                     | ABC               |
      | 8.7 Writing Off - Date of Validity                                      | 22/01/2020        |
      | 8.7 Writing Off - Quantity                                              | 1                 |
      | 8.7 Writing Off - Measurement Unit & Qualifier                          | KGM               |
    And I click on Submit
    Then I should see submitted page with the following response details for valid data
      | Status |
      | 202    |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following AdditionalDocument
      | Element           | Value            |
      | CategoryCode      | N                |
      | TypeCode          | 935              |
      | ID                | 12345/30.09.2019 |
      | LPCOExemptionCode | AC               |
      | Name              | DocumentName1    |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following AdditionalDocument
      | Element      | Value             |
      | CategoryCode | C                 |
      | TypeCode     | 514               |
      | ID           | GBEIR201909014000 |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following AdditionalDocument
      | Element      | Value        |
      | CategoryCode | C            |
      | TypeCode     | 506          |
      | ID           | GBDPO1909241 |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following AdditionalDocument
      | Element           | Value            |
      | CategoryCode      | N                |
      | TypeCode          | 935              |
      | ID                | 12345/30.07.2019 |
      | LPCOExemptionCode | AC               |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following AdditionalDocument
      | Element           | Value            |
      | CategoryCode      | N                |
      | TypeCode          | 935              |
      | ID                | 12345/30.08.2019 |
      | LPCOExemptionCode | AC               |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following AdditionalDocument
      | Element                   | Value            |
      | CategoryCode              | N                |
      | TypeCode                  | 935              |
      | ID                        | 12345/30.09.2019 |
      | LPCOExemptionCode         | AC               |
      | Submitter/Name            | ABC              |
      | EffectiveDateTime         | 22/01/2020       |
      | WriteOff/QuantityQuantity | 1                |
    And the unitCode attribute of node Declaration/GoodsShipment/GovernmentAgencyGoodsItem/AdditionalDocument/WriteOff/QuantityQuantity should be KGM

  Scenario: Section 3 Exporter fields are mapped to the correct XML elements
    When I navigate to the Simple Declaration page
    And I enter the following data
      | Field Name                       | Value                |
      | 3.1 Exporter - Name              | Transport du Tinfoil |
      | 3.1 Exporter - Street and Number | 1 Rue Aluminum       |
      | 3.1 Exporter - City              | Metalville           |
      | 3.1 Exporter - Country Code      | FR                   |
      | 3.1 Exporter - Postcode          | 07030                |
      | 3.2 Exporter - EORI              | FR12345678           |
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
      | Field Name            | Value      |
      | 3.18 Declarant - EORI | GB15263748 |
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
      | Field Name                        | Value          |
      | 3.15 Importer - Name              | Foil Solutions |
      | 3.15 Importer - Street and Number | Aluminium Way  |
      | 3.15 Importer - City              | Metalton       |
      | 3.15 Importer - Country Code      | UK             |
      | 3.15 Importer - Postcode          | ME7 4LL        |
      | 3.16 Importer - EORI              | GB87654321     |
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
      | Field Name                      | Value                   |
      | 3.24 Seller - Name              | Tinfoil Sans Frontieres |
      | 3.24 Seller - Street and Number | 123 les Champs Insulees |
      | 3.24 Seller - City              | Troyes                  |
      | 3.24 Seller - Country Code      | FR                      |
      | 3.24 Seller - Postcode          | 01414                   |
      | 3.24 Seller - Phone Number      | 003344556677            |
      | 3.25 Seller - EORI              | FR84736251              |
    And I click on Submit
    Then I should see submitted page with the following response details for valid data
      | Status |
      | 202    |
    And the submitted XML should include a GoodsShipment with the following Seller
      | Element             | Value                   |
      | Name                | Tinfoil Sans Frontieres |
      | Address/Line        | 123 les Champs Insulees |
      | Address/CityName    | Troyes                  |
      | Address/CountryCode | FR                      |
      | Address/PostcodeID  | 01414                   |
      | Communication/ID    | 003344556677            |
      | ID                  | FR84736251              |

  Scenario: Section 3 Buyer fields are mapped to the correct XML elements
    When I navigate to the Simple Declaration page
    And I enter the following data
      | Field Name                     | Value              |
      | 3.26 Buyer - Name              | Tinfoil R Us       |
      | 3.26 Buyer - Street and Number | 12 Alcan Boulevard |
      | 3.26 Buyer - City              | Sheffield          |
      | 3.26 Buyer - Country Code      | UK                 |
      | 3.26 Buyer - Postcode          | S1 1VA             |
      | 3.26 Buyer - Phone Number      | 00441234567890     |
      | 3.27 Buyer - EORI              | GB45362718         |
    And I click on Submit
    Then I should see submitted page with the following response details for valid data
      | Status |
      | 202    |
    And the submitted XML should include a GoodsShipment with the following Buyer
      | Element             | Value              |
      | Name                | Tinfoil R Us       |
      | Address/Line        | 12 Alcan Boulevard |
      | Address/CityName    | Sheffield          |
      | Address/CountryCode | UK                 |
      | Address/PostcodeID  | S1 1VA             |
      | Communication/ID    | 00441234567890     |
      | ID                  | GB45362718         |

  Scenario: Section 3 miscellaneous fields are mapped to the correct XML elements
    When I navigate to the Simple Declaration page
    And I enter the following data
      | Field Name                               | Value      |
      | 3.39 Authorisation holder - identifier 1 | GB62518473 |
      | 3.39 Authorisation holder - type code 1  | OK4U       |
      | 3.39 Authorisation holder - identifier 2 | GB98229822 |
      | 3.39 Authorisation holder - type code 2  | YAY1       |
      | 3.40 VAT Number (or TSPVAT) 1            | 99887766   |
      | 3.40 Role Code 1                         | VAT        |
      | 3.40 VAT Number (or TSPVAT) 2            | 99997777   |
      | 3.40 Role Code 2                         | RAT        |
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
    Then I should see submitted page with the following response details for valid data
      | Status |
      | 202    |
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
    And the currencyID attribute of node Declaration/GoodsShipment/GovernmentAgencyGoodsItem/Commodity/InvoiceLine/ItemChargeAmount should be GBP
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following DutyTaxFee
      | Element        | Value |
      | DutyRegimeCode | 100   |

  Scenario: Section 4.9 answers are mapped to the correct XML elements
    When I navigate to the Simple Declaration page
    And I enter the following data
      | Field Name                           | Value  |
      | 4.9 Amount - header                  | 99.32  |
      | 4.9 Currency - header                | GBP    |
      | 4.9 Type - header                    | AS     |
      | 4.9 Amount - item                    | 123.45 |
      | 4.9 Currency - item                  | USD    |
      | 4.9 Type - item                      | CD     |
      | 5.21 Place of loading - airport code | JFK    |
    And I click on Submit
    Then I should see submitted page with the following response details for valid data
      | Status |
      | 202    |
    And the submitted XML should include a GoodsShipment with the following CustomsValuation
      | Element                                    | Value  |
      | ChargeDeduction/ChargesTypeCode            | AS     |
      | ChargeDeduction/OtherChargeDeductionAmount | 99.32 |
    And the currencyID attribute of node Declaration/GoodsShipment/CustomsValuation/ChargeDeduction/OtherChargeDeductionAmount should be GBP
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following CustomsValuation
      | Element                                    | Value  |
      | MethodCode                                 | 1      |
      | ChargeDeduction/ChargesTypeCode            | CD     |
      | ChargeDeduction/OtherChargeDeductionAmount | 123.45 |
    And the currencyID attribute of node Declaration/GoodsShipment/GovernmentAgencyGoodsItem/CustomsValuation/ChargeDeduction/OtherChargeDeductionAmount should be USD
    And the submitted XML should include a GoodsShipment with the following Consignment
      | Element            | Value |
      | LoadingLocation/ID | JFK   |

  Scenario: Section 5 answers are mapped to the correct XML elements
    When I navigate to the Simple Declaration page
    And I enter the following data
      | Field Name                                  | Value |
      | 5.8 Destination country code                | GB    |
      | 5.14 Dispatch/export country code           | US    |
      | 5.15 Origin country code                    | MX    |
      | 5.15 Origin country code type               | 1     |
      | 5.16 Preferential origin country code       | BD    |
      | 5.16 Preferential origin country code type  | 2     |
      | 5.23 Goods Location - Name                  | DVR   |
      | 5.23 Goods Location - Type                  | B     |
      | 5.23 Goods Location - Country Code          | FR    |
      | 5.23 Goods Location - Address Type          | Z     |
    And I click on Submit
    Then I should see submitted page with the following response details for valid data
      | Status |
      | 202    |
    And the submitted XML should include a GoodsShipment with the following Destination
      | Element     | Value |
      | CountryCode | GB    |
    And the submitted XML should include a GoodsShipment with the following ExportCountry
      | Element | Value |
      | ID      | US    |
    And the submitted XML should include a Consignment with the following GoodsLocation
      | Element             | Value |
      | Name                | DVR   |
      | TypeCode            | B     |
      | Address/CountryCode | FR    |
      | Address/TypeCode    | Z     |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following Origin
      | Element     | Value |
      | CountryCode | MX    |
      | TypeCode    | 1     |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following Origin
      | Element     | Value |
      | CountryCode | BD    |
      | TypeCode    | 2     |

  Scenario: Section 6 GoodsMeasure and Packaging fields are mapped to the correct XML elements
    When I navigate to the Simple Declaration page
    And I enter the following data
      | Field Name               | Value                       |
      | 6.1 Net mass             | 5                           |
      | 6.2 Supplementary units  | 0                           |
      | 6.5 Gross mass           | 8                           |
      | 6.8 Description of goods | TSP no description required |
      | 6.9 Type of packages     | BF                          |
      | 6.10 Number of packages  | 1                           |
      | 6.11 Shipping marks      | TSP not required            |
    And I click on Submit
    Then I should see submitted page with the following response details for valid data
      | Status |
      | 202    |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following Commodity
      | Element                          | Value                       |
      | Description                      | TSP no description required |
      | GoodsMeasure/GrossMassMeasure    | 8                           |
      | GoodsMeasure/NetNetWeightMeasure | 5                           |
      | GoodsMeasure/TariffQuantity      | 0                           |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following Packaging
      | Element          | Value            |
      | TypeCode         | BF               |
      | QuantityQuantity | 1                |
      | MarksNumbersID   | TSP not required |
    And the submitted XML should include a Declaration with the following data elements
      | Element               | Value |
      | TotalGrossMassMeasure | 8     |

  Scenario: Section 6 Classification fields are mapped to the correct XML elements
    When I navigate to the Simple Declaration page
    And I enter the following data
      | Field Name                                               | Value    |
      | 6.14 Combined Nomenclature code id                       | 76071111 |
      | 6.14 Combined Nomenclature code identification type code | TSP      |
      | 6.15 TARIC code id                                       | 10       |
      | 6.15 TARIC code identification type code                 | TRC      |
      | 6.16 TARIC Add code id                                   | 1234     |
      | 6.16 TARIC Add code identification type code             | TRA      |
      | 6.17 National Additional code id                         | VATZ     |
      | 6.17 National Additional code identification type code   | GN       |
    And I click on Submit
    Then I should see submitted page with the following response details for valid data
      | Status |
      | 202    |
    And the submitted XML should include a Commodity with the following Classification
      | Element                | Value    |
      | ID                     | 76071111 |
      | IdentificationTypeCode | TSP      |
    And the submitted XML should include a Commodity with the following Classification
      | Element                | Value    |
      | ID                     | 10       |
      | IdentificationTypeCode | TRC      |
    And the submitted XML should include a Commodity with the following Classification
      | Element                | Value    |
      | ID                     | 1234     |
      | IdentificationTypeCode | TRA      |
    And the submitted XML should include a Commodity with the following Classification
      | Element                | Value    |
      | ID                     | VATZ     |
      | IdentificationTypeCode | GN       |
    And the submitted XML should include a Declaration with the following data elements
      | Element              | Value |
      | TotalPackageQuantity | 1     |

  Scenario: Section 7 answers are mapped to the correct XML elements
    When I navigate to the Simple Declaration page
    And I enter the following data
      | Field Name                                       | Value |
      | 7.2 Container                                    | 0     |
      | 7.4 Mode of transport code                       | 1     |
      | 7.9 ID of means of transport on arrival          | 12345 |
      | 7.9 Transport ID type                            | 10    |
      | 7.15 Nationality of means of transport at border | BR    |
    And I click on Submit
    Then I should see submitted page with the following response details for valid data
      | Status |
      | 202    |
    And the submitted XML should include a GoodsShipment with the following Consignment
      | Element                                      | Value |
      | ContainerCode                                | 0     |
      | ArrivalTransportMeans/ID                     | 12345 |
      | ArrivalTransportMeans/IdentificationTypeCode | 10    |
    And the submitted XML should include a Declaration with the following BorderTransportMeans
      | Element                     | Value |
      | ModeCode                    | 1     |
      | RegistrationNationalityCode | BR    |
@wip
  Scenario: Section 8 Quota and guarantee fields are mapped to the correct XML elements
    When I navigate to the Simple Declaration page
    And I enter the following data
      | Field Name                                       | Value |
      | Quota order number                               | 1     |
      | Guarantee type                                   | 0     |
      | GRN                                              | 1234  |
      | Other Guarantee Reference                        | 456   |
      | Access Code                                      | 90    |
      | Amount of import duty and other charges          | 2000  |
      | Currency Code                                    | GBP   |
      | Customs office of guarantee                      | 29    |
    And I click on Submit
    Then I should see submitted page with the following response details for valid data
      | Status |
      | 202    |
    And the submitted XML should include a Commodity with the following DutyTaxFee
      | Element                     | Value |
      | QuotaOrderID                | 1     |
    And the submitted XML should include a Declaration with the following ObligationGuarantee
      | Element                     | Value |
      | AmountAmount                | 2000  |
      | ID                          | 456   |
      | ReferenceID                 | 1234  |
      | SecurityDetailsCode         | 0     |
      | AccessCode                  | 90    |
      | GuaranteeOffice/ID          | 29    |
    And the currencyID attribute of node Declaration/ObligationGuarantee/AmountAmount/ should be GBP

  Scenario: Section 8 Nature of Transaction & Statistical Value fields are mapped to the correct XML elements
    When I navigate to the Simple Declaration page
    And I enter the following data
      | Field Name                       | Value |
      | 8.5 Nature of transaction        | 3     |
      | 8.6 Statistical value - amount   | 99    |
      | 8.6 Statistical value - currency | MXN   |
    And I click on Submit
    Then I should see submitted page with the following response details for valid data
      | Status |
      | 202    |
    And the submitted XML should include a GovernmentAgencyGoodsItem with the following data elements
      | Element                | Value |
      | TransactionNatureCode  | 3     |
      | StatisticalValueAmount | 99    |
    And the currencyID attribute of node Declaration/GoodsShipment/GovernmentAgencyGoodsItem/StatisticalValueAmount should be MXN
