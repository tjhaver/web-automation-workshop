class TMA
  attr_accessor :browser,
                :fill_step_hash,
                :current_user,
                :current_page,
                :ie

  def initialize
    self.create_browser
    self.set_timeout
    self.set_browser_experience
    page_object_array = []
    Dir["#{File.dirname(__FILE__)}/../pages/*.rb"].each { |f|
      page_name = f.gsub(/(.*\/)/, '').gsub('.rb', '').split('_').collect { |a| (a =~ /TMA\b/i ? a.upcase : a.capitalize) }.join('')
      page_object_array.push(page_name)
    }
    self.fill_step_hash = {}
    page_object_array.each { |x| self.fill_step_hash[x] = false }

    if DataHelper.environment_browser_type.downcase == 'ie'
      self.ie = true
    end
  end

  def create_browser

    case environment_browser_type.downcase
      when 'chrome'
        self.browser = Watir::Browser.new :chrome
      when 'firefox'
        self.browser = Watir::Browser.new :firefox
      when 'edge'
        self.browser = Watir::Browser.new :edge
      when 'safari'
        self.browser = Watir::Browser.new :safari
      when 'ie'
        self.browser = Watir::Browser.new :ie
      else
        raise 'Browser type not recognized.'
    end
  end

  def set_browser_experience
    screen_height = self.browser.execute_script("return screen.height;") - 30

    case ENV['device']
      when /desktop/i
        self.browser.driver.manage.window.maximize
      when /tablet/i
        self.browser.window.resize_to(775, screen_height)
        self.browser.window.move_to(0, 0)
      when /mobile/i
        self.browser.window.resize_to(400, screen_height)
        self.browser.window.move_to(0, 0)
      when /\d+,\d+/i
        screen_width = ENV['device'].gsub(/,\d+/, '').to_i
        screen_height = ENV['device'].gsub(/\d+,/, '').to_i
        self.browser.window.resize_to(screen_width, screen_height)
        self.browser.window.move_to(0, 0)
      else
        self.browser.driver.manage.window.maximize
    end
  end

  def set_timeout
    self.browser.driver.manage.timeouts.implicit_wait = 10
    self.browser.driver.manage.timeouts.script_timeout = 30
    self.browser.driver.manage.timeouts.page_load = 30
  end

end