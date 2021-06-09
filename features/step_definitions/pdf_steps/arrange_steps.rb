When(/^the user opens the (.+) PDF(?: from the (.*))?$/) do |pdf_file, external_locator|
  if external_locator.nil?
    @pdf = PDF::Reader.new("#{DATA_SOURCE_DIR}/input_data/#{pdf_file}.pdf")
  else
    source_directory = get_data_from_yml_file('external_file_locations.yml')[application_environment][external_locator.upcase.tr(' ', '_')]
    @pdf = PDF::Reader.new("#{source_directory}#{pdf_file}.pdf")
  end
end

When(/^a PDF opens in the browser$/) do
  @browser.window(url: /pdf/).use if @browser.window(url: /pdf/).exists?
  io = open(@browser.url)
  @pdf = PDF::Reader.new(io)
end