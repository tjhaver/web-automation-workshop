When(/^the user (check|uncheck)s (.*)$/) do |action, check_boxes|
  check_boxes.split(', ').each do |check_box|
    @current_page.enter_element_value(check_box, action)
  end
end

When(/^the user (?:selects|fills in) "(.+)" for (.+)$/) do |value, page_element|
  @current_page.enter_element_value(page_element, value)
end

When(/^the user (?:fills|modifies) the (?:.+) page(?: with (.*))?$/) do |locator|
  if locator.nil?
    @current_page.instantiate_page_data_object
  else
    @current_page.instantiate_page_data_object(locator.upcase.tr(' ', '_'))
  end

  @current_page.fill_all_form_data
  @tma.fill_step_hash[@current_page.class.to_s] = true
end

When(/^the user selects the (\d)(?:st|nd|rd|th)? (.*) radio button$/) do |index, page_element|
  index_option = index.to_i - 1
  radio_button_name = @current_page.send(page_element.downcase.tr(' ', '_')+ '_element').attribute('name')
  @browser.radio(:name => "#{radio_button_name}", :index => index_option).set
end

When(/^the user selects the (\d+)(?:st|nd|rd|th) option from the (.*)$/) do |index, field_name|
  Watir::Wait.until(timeout: 10) { @current_page.send(field_name.downcase.tr(' ', '_')+ '_element').present? }
  @current_page.enter_element_value(field_name.downcase.tr(' ', '_'), @current_page.send(field_name.downcase.gsub(' ', '_') + '_element').options[index.to_i].text)
end

When(/^the user selects an option from the (.*) which contains the value "(.*)"$/) do |field_name, value|
  Watir::Wait.until(timeout: 10) { @current_page.send("#{field_name.tr(' ', '_').downcase}_element").present? }
  @current_page.send("#{field_name.tr(' ', '_').downcase}_element").options.each do |option|
    if option.text.include? value
      option.select
      break
    end
  end
end

When(/^the user selects the (\d+)(?:st|nd|rd|th)? (.*) result$/) do |index, page_element|
  index.to_i.times do
    @browser.send_keys(:arrow_down)
  end
  step "the user clicks the #{page_element}"
end

When(/^the user captures:$/) do |table_of_data|
  table_of_data.raw.flatten.each do |page_element|
    name = page_element.downcase.tr(' ', '_')
    value = @current_page.send(page_element.downcase.tr(' ', '_'))
    instance_variable_set("@#{name}", value)
  end
end

When(/^the user enters the captured (.+) value for (.+)$/) do |source, target|
  value = instance_variable_get("@#{source.tr(' ','_').downcase}")
  @current_page.enter_element_value(target, value.to_s)
end

When /^the user presses the following keyboard key(?:s)?:$/ do |table_of_data|
  begin
    @array = table_of_data.raw.flatten.collect{|key| key.size > 1 ? make_symbol(key) : key}
    @browser.send_keys(@array)
  rescue Exception => e
    verbose_messages(e)
  end
end