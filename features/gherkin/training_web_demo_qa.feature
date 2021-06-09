Feature: Web Training Feature with DemoQA


  Scenario: Sample navigation for element interaction on DemoQA
    Given the user navigates to the Demo QA Home page
    When the user clicks the elements card
    Then the application navigates to the Demo QA Elements page


  Scenario: Sample navigation for element interaction on DemoQA
    Given the user navigates to the Demo QA Elements page
    And the user clicks Elements Check Box
    And the application navigates to the Demo QA Check Box page
    When the user clicks home
    Then the user validates the home checkbox is checked
