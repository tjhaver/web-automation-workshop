Feature: Generate code metrics reports

  @cuke_sniffer
  Scenario: Generate a cuke sniffer project level report
    Given the user updates the rules for cuke sniffer
    When the user runs the cuke sniffer tool
    Then the output cuke sniffer report will be generated

  Scenario: Generate a cuke sniffer project level report for given directory
    Given the user updates the rules for cuke sniffer
    When the user runs the cuke sniffer tool against the test directory
    Then the output cuke sniffer report will be generated