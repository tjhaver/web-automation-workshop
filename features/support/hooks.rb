total_passed = 0
total_failed = 0

Before ('not @cuke_sniffer') do |scenario|
  begin
    $start_time = Time.now

    stop_browser_and_driver_server if ENV['browser_kill'] == 'true'

    @scenario = scenario.name

    keep_trying_to_set(2) {
      @tma = TMA.new
      @browser = @tma.browser
    }
    TMAData.set_tma_object(@tma)

  rescue Exception => e
    p e.message
    p 'Could not open browser'
  end
end


After ('not @cuke_sniffer') do |scenario|

  scenario_folder = output_folder + '/' + ENV['TIMESTAMP'][0, 10] + '/failure screenshots/'

  script_name = scenario.name

  screenshot_file = scenario_folder + script_name.gsub(/[\/\\| <>"\*;:,=\n\r]+/, '_')[0..90] + '.png'
  current_path = ''

  if scenario.failed?
    begin
      total_failed += 1

      screenshot_file.split(/\//).map {|m| m.split(/\\/)}.flatten.each {|folder|
        next if folder =~ /\.png/
        current_path += folder + '/'
        Dir.mkdir(current_path) unless File.exists?(current_path)
      }

      @browser.screenshot.save screenshot_file
      embed screenshot_file, 'image/png'

      encoded_img = @browser.driver.screenshot_as(:base64)
      embed("data:image/png;base64,#{encoded_img}", 'image/png')

    rescue Exception => e
      p e.message
      p 'Could not capture screenshot'
    end
  else
    total_passed +=1
  end

  close_current_browser
  stop_browser_and_driver_server if ENV['browser_kill'] == 'true'
end