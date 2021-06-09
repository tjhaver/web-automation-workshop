Then(/^the user validates the (.*) value (?:defaults to|is)( not)? "(.*)"$/) do |page_element, is_not, value|
  expectation = (is_not.nil? ? true : false)
  actual = @current_page.confirm_element_value(page_element, value)
  expect(actual).to eq(expectation)
end

Then(/^the user validates the field values are correct for (.*)$/) do |locator|
  @current_page.get_expected_data(locator).each do |page_element, expected_value|
    next if expected_value.nil?
    field_type = @current_page.send((page_element.tr(' ', '_') + '_element').downcase).class.to_s
    case field_type
      when /radio/i
        expect(@current_page.send((page_element + "_#{expected_value}_selected?").tr(' ', '_').downcase)).to eq(true)
      when /checkbox/i
        expect(@current_page.send((page_element + '_checked?').tr(' ', '_').downcase)).to eq((expected_value == 'check' ? true : false))
      else
        actual_data = @current_page.send(page_element.tr(' ', '_').downcase).strip
        expect((actual_data == expected_value)).to eq(true), page_element.to_s + "\nexpected #{actual_data} to be #{expected_value}"
    end
  end
end

Then(/^the user validates the (.*) radio group (has a|has no) selection$/) do |page_element, expectation|
  expect(@current_page.radio_list_for_group(page_element).inject(0) { |sum, radio|
    sum += 1 if radio.set?
    sum
  }).to eq(expectation == 'has a' ? 1 : 0)
end

Then(/^the user validates the (.+) checkbox is (checked|unchecked|disabled|enabled)$/) do |checkbox_name, checkbox_status|
  case checkbox_status.upcase
    when 'CHECKED'
      expect(@current_page.send("#{checkbox_name}_element").parent.element.checkbox.checked?).to eq(true)
    when 'UNCHECKED'
      expect(@current_page.send("#{checkbox_name}_element").parent.element.checkbox.checked?).to eq(false)
    when 'DISABLED'
      expect(@current_page.send("#{checkbox_name}_element").parent.element.checkbox.disabled?).to eq(true)
    when 'ENABLED'
      expect(@current_page.send("#{checkbox_name}_element").parent.element.checkbox.enabled?).to eq(true)
  end
end

Then(/^the user validates the page (displays|does not display) the (.*) (?:field|dialog|element|section|checkbox)$/) do |expectation, field|
  expect(@current_page.send(field.tr(' ', '_').downcase + '_element').exists? &&
    @current_page.send(field.tr(' ', '_').downcase + '_element').present?).to eq((expectation == 'displays' ? true : false))
end

Then(/^the user validates the (pick list|radio group) values for (.*) are correct(?: for (.+))?$/) do |field_type, field, condition|
  pick_list_key_for_yml = (condition.nil? ? field : "#{condition}_#{field}").gsub(' ', '_').upcase
  field_name = field.downcase.tr(' ', '_')

  parent_key = field_type == 'pick list' ? 'SELECT_LISTS' : 'RADIO_GROUP'
  expected_list_values = @current_page.get_list_values(parent_key, pick_list_key_for_yml)
  case field_type
    when 'pick list'
      actual_field_values = nil
      keep_trying_to_set(5) {
        actual_field_values = @current_page.send(field_name + '_element').element.elements.map { |option| (option.class.to_s == 'String' ? option.strip : option.text.strip) }
      }
    when 'radio group'
      actual_field_values = @current_page.labels_from_radio_group(field_name)
    else
      raise 'Field type not supported in this step definition'
  end
  expect(actual_field_values).to eq(expected_list_values)
end

Then(/^the user validates the page (displays|does not display) the following field(?:s)?(?: as (enabled|disabled))?:$/) do |expectation, status, table_of_fields|
  table_of_fields.raw.flatten.each do |field|
    field_type = @current_page.send((field.tr(' ', '_') + '_element').downcase).class.to_s
    if field_type =~ /select/i
      @current_page.send(field.tr(' ', '_').downcase + '_element').exists?
    else
      expect(@current_page.send(field.tr(' ','_').downcase + '_element').exists? &&
        @current_page.send(field.tr(' ','_').downcase + '_element').present?).to eq(expectation == 'displays' ? true : false)
      expect(@current_page.send(field.tr(' ','_').downcase + '_element').enabled?).to eq(status == 'enabled' ? true : false) unless status.nil?
    end
  end
end

Then(/^the user validates the (error message|warning message|success message|text) for (.+) is (not )?displayed(?: in the (.*))?$/) do |message_type, message_key, not_displayed, area|
  candidate_text = case area
                     when nil
                       @current_page.text
                     when /alert/
                       @browser.alert.text
                     else
                       elementify(area).text
                   end

  message = @current_page.get_message(message_type, message_key)
  verbose_messages(candidate_text, message)

  if message.class == Regexp
    not_displayed ? (expect(candidate_text).to_not match(message)) : (expect(candidate_text).to match(message))
  else
    message.gsub!(/\s+/,' ')
    not_displayed ? (expect(candidate_text).to_not include(message)) : (expect(candidate_text).to include(message))
  end
end

Then(/^the user validates the (title|url) of the browser window contains (.*)$/) do |title_or_url, expected|
  Watir::Wait.until(timeout: 10) { @browser.title =~ Regexp.new(expected) or @browser.url =~ Regexp.new(expected) }
  if title_or_url == 'url'
    expect(@browser.url).to include(expected)
  else
    expect(@browser.title).to include(expected)
  end
end

Then(/^the user validates the (.+) (?:button|drop down|text field|radio button|checkbox) is (disabled|enabled)$/) do |element_name, element_status|
  case element_status.upcase
    when 'DISABLED'
      expect(@current_page.send("#{element_name}_element").disabled?).to eq(true)
    when 'ENABLED'
      expect(@current_page.send("#{element_name}_element").enabled?).to eq(true)
  end
end

Then(/^the user validates the (.*) HTML attribute with value "(.+)" for (.*) is( not)? present$/) do |attribute, value, page_element, expectation|
  if page_element =~ /frame/i
    expect(@browser.iframe(attribute.to_sym, value).exists?).to eq(true)
  else
    expect((@current_page.send(page_element.downcase.tr(' ', '_') + '_element').attribute(attribute) =~ Regexp.new(value))).to eq((expectation == 'not' ? false : true))
  end
end

Then(/^the user validates the (.*) (color style|box shadow|background color) (should|should not) be (.*)$/) do |page_element, style, expectation, message_key|
  message = @current_page.get_color_scheme(message_key)
  message.gsub!(/\s+/, ' ')

  case style
    when 'color style'
      color_rgba_format = @current_page.send(page_element.downcase.gsub(' ', '_') + '_element').style('color')
      @color_array = color_rgba_format.split(',').each do |remove_non_digits|
        remove_non_digits.gsub!(/\D/, '')
      end
    when 'box shadow'
      color_rgba_format = @current_page.send(page_element.downcase.gsub(' ', '_') + '_element').style('box-shadow')
      @color_array = color_rgba_format.gsub(/\d+px/, '').split(',').each do |remove_non_digits_and_pixels|
        remove_non_digits_and_pixels.gsub!(/\D/, '')
      end
    when 'background color'
      color_rgba_format = @current_page.send(page_element.downcase.gsub(' ', '_') + '_element').style('background-color')
      @color_array = color_rgba_format.split(',').each do |remove_non_digits|
        remove_non_digits.gsub!(/\D/, '')
      end
  end
  color_converted_to_hex = '#' + @color_array.map! { |name| name.to_i.to_s(16) }.join
  expect(color_converted_to_hex =~ Regexp.new(message)).to eq(expectation == 'should' ? true : false)
end

Then(/^the user validates the following captured element values( do not)? exist in the (.+):$/) do |do_not, containing_object, table_of_data|
  elements_to_confirm = Array.new
  expectation = (do_not.nil? ? true : false)

  table_of_data.raw.flatten.each do |page_element|
    elements_to_confirm << instance_variable_get("@#{page_element.downcase.tr(' ', '_')}")
  end

  elements_to_confirm.each do |expected_text|
    expect(@current_page.send("#{containing_object.downcase.tr(' ', '_')}").include? expected_text).to eq(expectation)
  end
end

Then(/^the user validates the following captured information is formatted as (.+)(?: in the (.*))?:$/) do |format, containing_object, table_of_data|
  elements_to_confirm = Array.new
  table_of_data.raw.flatten.each do |page_element|
    elements_to_confirm << instance_variable_get("@#{page_element.downcase.tr(' ', '_')}")
  end

  case format
    when /surname/i
      surname = "#{elements_to_confirm[1].to_s}, #{elements_to_confirm[0].to_s}"
      containing_object ? (expect(elementify(containing_object).text).to include(surname)) : (expect(@current_page.text).to include(surname))
    when /masked/i
      masked = elements_to_confirm[0].to_s
      containing_object ? (expect(elementify(containing_object).attribute('value')).to include(masked)) : (expect(@current_page.text).to include(masked))
    when /ssn|social security number/i
      ssn = elements_to_confirm[0].to_s
      containing_object ? ((expect(elementify(containing_object).text).to include(ssn)) && (expect(ssn).to match(/\d{3}-\d{2}-\d{4}/))) : (expect(ssn).to match(/\d{3}-\d{2}-\d{4}/))
    when /select list options/i
      available_options = elementify(containing_object).options.map { |option| option.text }
      elements_to_confirm.each do |expected_option|
        (expect(available_options).to include(expected_option))
      end
    else
      fail "The following format is not recognized: #{format}"
  end
end

Then(/^the user validates that the (.+) select list (includes|does not include) (.+)$/) do |page_element, include_or_not, locator|
  expected_data = get_data_from_yml_file(File.join('data_files', 'expected_data', @current_page.file_name))
  correct_value = expected_data.fetch(locator.upcase.tr(' ', '_'))
  actual_values = @current_page.send("#{page_element.downcase.tr(' ', '_')}_options")

  if include_or_not == 'includes'
    expect(actual_values).to include correct_value
  else
    expect(actual_values).not_to include correct_value
  end
end