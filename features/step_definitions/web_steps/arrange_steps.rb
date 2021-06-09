When(/^the user navigates to (.+) directly(?: on the (.+) page)?$/) do |location, page_name|
  if page_name.nil?
    url = get_data_from_yml_file('environment_urls.yml')["#{application_environment}"] + location
    @browser.goto(url)
  else
    url = get_data_from_yml_file("input_data/#{file_name_for(page_name)}")[location.upcase.gsub(' ', '_')]
    url = on(page_class_name_for(page_name)).page_url_value + url
    @browser.goto(url)
    step "the application navigates to the #{page_name} page"
  end
end

When(/^the user navigates to the (.+) page$/) do |page_name|
  page_name = page_name.split(' ').map(&:capitalize).join(' ')
  visit_page(page_class_name_for(page_name))
  step "the application navigates to the #{page_name} page"
end

When(/^the user navigates to the (.+) >> (.+) page$/) do |main_menu,sub_menu|
  [main_menu,sub_menu].each do |link|
    keep_trying_to_set(3) do
      Watir::Wait.until(timeout: 60) {@current_page.send(link.tr(' ','_').downcase + '_element').exists?}
    end
  end
  @current_page.send(main_menu.tr(' ','_').downcase + '_element').focus
  @current_page.send(main_menu.tr(' ','_').downcase + '_element').fire_event 'onmouseover'
  @current_page.send(sub_menu.tr(' ','_').downcase + '_element').focus
  @current_page.send(sub_menu.tr(' ','_').downcase + '_element').click
  step "the application navigates to the #{main_menu} #{sub_menu} page"
end

When(/^the user closes the active window$/) do
  begin
    @browser.windows.last.use.close
  rescue Exception => e
    verbose_messages(e)
  ensure
    @browser.windows.first.use
  end
end

When(/^the user closes the browser$/) do
  @browser.close
end

When(/^the user opens a new browser$/) do
  keep_trying_to_set(2){
    @browser = @tma.create_browser
    @tma.set_browser_experience
  }
end

When(/^the application (?:navigates to|remains on) the (.+) page$/) do |page_name|
  Watir::Wait.until(timeout: 20) {application_is_on_page?(page_name)}
  expect(application_is_on_page?(page_name)).to eq(true)
end

When(/^the user clicks(?: the)? (.+)$/) do |page_element|
  Watir::Wait.until(timeout: 10) {elementify(page_element).exists?}
  elementify(page_element).focus
  elementify(page_element).click
end

When(/^the user goes back to the previous page$/) do
  @current_page.navigate_back
end

When(/^take a screenshot$/) do
  @browser.windows.last.use

  output_folder = (ENV['output_folder'] || 'features/output') + '/' + ENV['TIMESTAMP'][0,10]
  scenario_folder = output_folder + '/success screenshots/'
  screenshot_file = File.join(scenario_folder, "#{@scenario}_#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}.png") # TODO - sanitize filename
  current_path = ''

  screenshot_file.split(/\//).map{|m| m.split(/\\/)}.flatten.each {|folder|
    next if folder =~ /\.png/
    current_path += folder + '/'
    next if folder.downcase =~ /:/
    Dir.mkdir(current_path) unless File.exists?(current_path)
  }

  @browser.screenshot.save screenshot_file
  embed screenshot_file, 'image/png'
end

When(/^(?:a new browser window opens|the browser window is closed)$/) do
  @browser.windows.last.use
end

When(/^the user (confirms|cancels) on the alert box$/) do |action|
  Watir::Wait.until(timeout: 10) {@browser.alert.exists?}
  if action == 'confirms'
    @browser.alert.ok
  else
    @browser.alert.close
  end
end

When(/^the user waits for (\d+) second(?:s)?$/) do |time|
  sleep time
end

When(/^the browser is refreshed$/) do
  @browser.refresh
end

When(/^the user focuses on(?: the)? (.+)$/) do |page_element|
  Watir::Wait.until(timeout: 10) {@current_page.send(page_element.tr(' ','_').downcase + '_element').exists?}
  @current_page.send(page_element.tr(' ','_').downcase + '_element').focus
end