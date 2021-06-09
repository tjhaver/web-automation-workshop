Feature: Web Training Feature with Azure DevOps

  @testcaseid12345
  Scenario: Validate Azure DevOps Services URL
    Given the user navigates to the Azure Test Plans Home page
    When the user clicks Pricing
    And the application navigates to the Pricing for Azure DevOps page
    Then the user validates the url of the browser window contains services


  Scenario: Validate Azure Pipelines Individual Service option
    Given the user navigates to the Azure Test Plans Home page
    And the user clicks Pricing
    And the application navigates to the Pricing for Azure DevOps page
    When the user clicks Azure Pipelines Start Free
    And the application navigates to the Microsoft Account Sign In page
    Then the user validates the page displays the sign in field


  Scenario: Validate Azure DevOps Service options the bad way
    Given the user navigates to the Azure Test Plans Home page
    When the user clicks Pricing
    And the application navigates to the Pricing for Azure DevOps page
    Then the user validates the page displays the Azure Pipelines Service field
    And the user validates the page displays the Azure Artifacts Service field
    And the user validates the page displays the Basic Plan Licenses field
    And the user validates the page displays the Basic plus Test Plans Licenses field


  Scenario: Validate Azure DevOps Service options the good way
    Given the user navigates to the Azure Test Plans Home page
    When the user clicks Pricing
    And the application navigates to the Pricing for Azure DevOps page
    Then the user validates the page displays the following fields:
      | Azure Pipelines Service         |
      | Azure Artifacts Service         |
      | Basic Plan Licenses             |
      | Basic plus Test Plans Licenses  |
