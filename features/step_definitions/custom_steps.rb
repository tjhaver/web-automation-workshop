Given(/^the user updates the rules for cuke sniffer$/) do
  customization_of_rules
end

When(/^the user runs the cuke sniffer tool(?: against the (.+) directory)?$/) do |directory|
  execute_cuke_sniffer(directory)
end

Then(/^the output cuke sniffer report will be generated$/) do
  generate_cuke_sniffer_output
end