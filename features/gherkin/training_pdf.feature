Feature: PDF Training Feature


  Scenario: Validate PDF orientation for Azure Test Plans Documentation with positive case
    Given the user navigates to the Azure Test Plans Documentation page
    And the user clicks Download PDF
    When a PDF opens in the browser
    Then the user validates the PDF orientation of the 1st page is "portrait"


  Scenario: Validate PDF orientation for Azure Test Plans Documentation with negative case
    Given the user navigates to the Azure Test Plans Documentation page
    And the user clicks Download PDF
    When a PDF opens in the browser
    Then the user validates the PDF orientation of the 1st page is "portrait"
    And the user validates the PDF orientation of the 1st page is not "landscape"


  Scenario: PDF opened from input directory validates text presence
    When the user opens the responsive-web-design-testing PDF
    Then the user validates the PDF text includes "Perfecto"
    And the user validates the PDF text does not include "BrowserStack"


  Scenario: PDF opened from input directory validates text presence on a page
    When the user opens the responsive-web-design-testing PDF
    Then the user validates the 12th page of the PDF text includes "Perfecto"
    And the user validates the 1st page of the PDF text does not include "BrowserStack"


  Scenario: PDF opened from input directory validates text presence from data files
    When the user opens the responsive-web-design-testing PDF
    Then the user validates the text for test case is present in the responsive-web-design-testing PDF
    And the user validates the text for pokemon is not present in the responsive-web-design-testing PDF


  Scenario: PDF opened from web navigation
    Given the user navigates to the Perfecto Mobile Responsive Web page
    And the user clicks the responsive web testing checklist
    When a PDF opens in the browser
    Then the user validates the PDF text includes "Responsive Web Testing Checklist"


  Scenario: PDF opened from input directory validates document values from data files
    When the user opens the responsive-web-design-testing PDF
    Then the user validates the document values are correct for the responsive-web-design-testing PDF


  Scenario: PDF opened from input directory validates document values
    When the user opens the responsive-web-design-testing PDF
    Then the user validates the document values are correct for the responsive-web-design-testing PDF
    And the user validates the Author of the PDF is "Perfecto Mobile - Eran Kinsbruner"
    And the user validates the Author of the PDF is not "Bill Gates"
    And the user validates the Creation Date of the PDF is "D:20160322213700-04'00'"
    And the user validates the Creator of the PDF is "Adobe InDesign CC 2015 (Macintosh)"
    And the user validates the Keywords of the PDF is "Complete Guide, Build Responsive Web Design Test Strategy, responsive web, perfecto mobile, white paper, perfecto paper"
    And the user validates the Modification Date of the PDF is "D:20160323094623-04'00'"
    And the user validates the Producer of the PDF is "Adobe PDF Library 15.0"
    And the user validates the Subject of the PDF is "Complete Guide to Building a Responsive Web Design Test Strategy"
    And the user validates the Title of the PDF is "Complete Guide to Building a Responsive Web Design Test Strategy"
    And the user validates the version of the PDF is "1.7"
    And the user validates the page count of the PDF is "12"
    And the user validates the PDF text includes "Perfecto"
    And the user validates the PDF text does not include "Pokemon"
    And the user validates the 12th page of the PDF text includes "Perfecto"
    And the user validates the 1st page of the PDF text does not include "Pokemon"
    And the user validates the PDF orientation of the 1st page is "portrait"
    And the user validates the PDF orientation of the 1st page is not "landscape"
