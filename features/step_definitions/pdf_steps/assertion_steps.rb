Then(/^the user validates the text for (.+) is (not )?present in the (.+) PDF(?: on page (\d+))?$/) do |message_key, not_present, pdf_file, page_number|
  pdf_file = pdf_file.gsub(/[ -]/, '_')
  message = get_data_from_yml_file("expected_data/#{pdf_file}.yml")[make_const(message_key)]

  if page_number.nil?
    candidate_text = @pdf.pages.map(&:text).join(' ').gsub(/\\n|\s+/,' ')
  else
    candidate_text = @pdf.pages[page_number.to_i - 1].text.gsub(/\\n|\s+/,' ')
  end

  if message.class == Regexp
    not_present ? (expect(candidate_text).to_not match(message)) : (expect(candidate_text).to match(message))
  else
    message.gsub!(/\s+/,' ')
    not_present ? (expect(candidate_text).to_not include(message)) : (expect(candidate_text).to include(message))
  end
end

Then(/^the user validates the PDF text (includes|does not include) "(.+)"$/) do |expectation, value|
  if expectation == 'includes'
    expect(@pdf.pages.map(&:text).join(' ')).to include value
  else
    expect(@pdf.pages.map(&:text).join(' ')).not_to include value
  end
end

Then(/^the user validates the (\d+)(?:st|nd|rd|th) page of the PDF text (includes|does not include) "(.+)"$/) do |page, expectation, value|
  page_number = page.to_i - 1
  if expectation == 'includes'
    expect(@pdf.pages[page_number].text).to include value
  else
    expect(@pdf.pages[page_number].text).not_to include value
  end
end

Then(/^the user validates the PDF orientation of the (\d+)(?:st|nd|rd|th) page is( not)? "(portrait|landscape)"$/) do |page, is_not, orientation|
  page_number = page.to_i - 1
  expectation = (is_not.nil? ? true : false)
  expect(@pdf.pages[page_number].orientation == orientation).to eq(expectation)
end

Then(/^the user validates the (.+) of the PDF is( not)? "(.+)"$/) do |pdf_info, is_not, value|
  expectation = (is_not.nil? ? true : false)
  case pdf_info
    when /author/i
      expect(@pdf.info[:Author].to_s == value).to eq(expectation)
    when /creation/i
      expect(@pdf.info[:CreationDate].to_s == value).to eq(expectation)
    when /creator/i
      expect(@pdf.info[:Creator].to_s == value).to eq(expectation)
    when /keywords/i
      expect(@pdf.info[:Keywords].to_s == value).to eq(expectation)
    when /mod/i
      expect(@pdf.info[:ModDate].to_s == value).to eq(expectation)
    when /page/i
      expect(@pdf.page_count.to_s == value).to eq(expectation)
    when /producer/i
      expect(@pdf.info[:Producer].to_s == value).to eq(expectation)
    when /subject/i
      expect(@pdf.info[:Subject].to_s == value).to eq(expectation)
    when /title/i
      expect(@pdf.info[:Title].to_s == value).to eq(expectation)
    when /version/i
      expect(@pdf.pdf_version.to_s == value).to eq(expectation)
    else
      fail "no matching document information type for #{pdf_info} found!"
  end
end

Then(/^the user validates the document values are correct for the (.+) PDF$/) do |pdf_file|
  pdf_file = pdf_file.gsub(/[ -]/, '_')
  document_values = TMAData.merged_with_default('expected_data/' + pdf_file + '.yml', 'DOCUMENT_VALUES')
  document_values.each do |attribute, expected_value|
    next if expected_value.nil?
    case attribute
      when /page/i
        expect(@pdf.page_count.to_s).to eq(expected_value)
      when /version/i
        expect(@pdf.pdf_version.to_s).to eq(expected_value)
      else
        pdf_attribute = attribute.split('_').map!(&:capitalize).join
        actual_data = @pdf.info[pdf_attribute.to_sym].to_s
        expect(actual_data).to eq(expected_value)
    end
  end
end