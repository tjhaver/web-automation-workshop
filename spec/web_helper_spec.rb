require 'spec_helper'

describe 'web_helper' do

  context 'environment_url' do

    it 'will return environment url' do
      expect(environment_url).to eq('https://www.someQAenv.com/')
    end

  end

  context 'base_url' do

    it 'will return QA base url when app env is set' do
      ENV['app_env'] = 'QA'
      expect(base_url).to eq('https://www.someQAenv.com/')
    end

  end

  context 'environment_browser_type' do

    it 'will return ie as browser when browser_type is nil' do
      expect(environment_browser_type).to eq('chrome')
    end

    it 'will return browser_type when not nil' do
      ENV['browser_type'] = 'firefox'
      expect(environment_browser_type).to eq('firefox')
    end

  end

  context 'close_current_browser' do

    it 'will close browser when close browser is true' do
      expect(@browser.exists?).to eq(true)
    end

    it 'will not close browser when close browser is false' do
      close_current_browser
      expect(@browser.exists?).to eq(false)
    end

  end

  context 'close_browser' do

    it 'will return true if close_browser is nil' do
      expect(close_browser).to eq 'true'
    end

    it 'will return true if close_browser is true' do
      expect(close_browser).to eq 'true'
    end

    it 'will return false if close_browser is not nil and also not true' do
      ENV['close_browser'] = 'false'
      expect(close_browser).to eq 'false'
    end

  end

end