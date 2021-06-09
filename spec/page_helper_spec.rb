require 'spec_helper'

describe 'page_helper' do

  context 'page_class_name_for' do

    it 'will return page class name if is a class' do
      expect(page_class_name_for('sample')).to eq(SamplePage)
    end

    it 'will fail when string passed in is not an acual class' do
      expect{ page_class_name_for('something') }.to raise_exception(NameError)
    end
  end

  context 'file_name_for' do

    it 'will return the name of the .yml file associated to what is passed in is class' do
      expect(file_name_for('sample')).to eq('sample_page_data.yml')
    end

    it 'will fail when argument is not a class' do
      expect{ file_name_for('something') }.to raise_exception(NameError)
    end
  end

  context 'application_is_on_page?' do

    it 'will return true when the application is on the right page' do
      @browser.goto(environment_url)
      expect(application_is_on_page?('sample')).to eq(true)
    end

    it 'will return false when application is not correct page' do
      expect(application_is_on_page?('test')).to eq(false)
    end

    it 'will raise error when argument is not a class' do
      expect{ application_is_on_page?('something') }.to raise_exception(NameError)
    end

  end

end