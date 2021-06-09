ROOT_DIR = File.join(File.dirname(__FILE__), '..')
$LOAD_PATH.unshift(ROOT_DIR)

require 'env'

RSpec.configure do |c|

  c.before(:all) do
    @tma = TMA.new
    @browser = @tma.browser
    @browser.goto(environment_url)

    on_page(page_class_name_for('sample'))
  end

  c.after(:all) do
    close_current_browser
    ENV['verbose'] = nil
  end

end
