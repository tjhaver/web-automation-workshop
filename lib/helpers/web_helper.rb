require_relative 'data_helper.rb'

module WebHelper
  include DataHelper

  def environment_url
    url = get_data_from_yml_file('environment_urls.yml')[application_environment]
    raise "Unknown Environment: \"#{application_environment}\"" unless url
    url
  end

  def base_url
    get_data_from_yml_file('environment_urls.yml')["#{application_environment}_BASE_URL"]
  end

  def environment_browser_type
    ENV['browser_type'].nil? ? 'chrome' : ENV['browser_type']
  end

  def close_browser
    ENV['close_browser'].nil? || ENV['close_browser'] == 'true' ? 'true' : 'false'
  end

  def close_current_browser
    begin
      @browser.close if (close_browser == 'true')
    rescue Exception => e
      verbose_messages(
          e.message,
          "ENV[close_browser] is set to #{close_browser}",
          'Browser is either already closed or Driver Server has lost control'
      )
    end
  end

  def stop_browser_and_driver_server
    case environment_browser_type.downcase
      when 'ie'
        system('taskkill /IM IEDriverServer.exe /T /F')
        system('taskkill /IM iexplore.exe /T /F')
      when 'chrome'
        system('taskkill /IM chromedriver.exe /T /F')
        system('taskkill /IM chrome.exe /T /F')
      when 'firefox'
        system('taskkill /IM geckodriver.exe /T /F')
        system('taskkill /IM firefox.exe /T /F')
      when 'edge'
        system('taskkill /F /IM MicrosoftWebDriver.exe /T')
        system('taskkill /F /IM MicrosoftEdge.exe /T')
      else
        raise 'Browser type not recognized.'
    end
  end

  def kill_task(task_name)
    system("taskkill /IM #{task_name} /T /F")
  end

end