require 'spec_helper'

describe 'tma_data' do

  context 'load_data_for' do

    it 'will create an object with all keys from .yml file that matches parameter' do
      expect(@current_page.load_data_for('valid personal login')).to eq({'PERSONAL_USERNAME' => 'valid-user', 'PERSONAL_PASSWORD' => 'valid-password'})
    end

    it 'will fail if no keys match input' do
      expect{ @current_page.load_data_for('test') }.to raise_exception(RuntimeError)
    end

  end

  context 'get_input_data' do

    it 'will read data from input_data yml file for current page and find key that matches parameter' do
      expect(@current_page.get_input_data('valid personal login')).to eq({'PERSONAL_USERNAME' => 'valid-user', 'PERSONAL_PASSWORD' => 'valid-password'})
    end

    it 'will fail when key not found in yml file' do
      expect{ @current_page.get_input_data('test') }.to raise_exception(RuntimeError)
    end

  end

  context 'get_expected_data' do

    it 'will read data from expected_data yml file for current page and find key that matches parameter' do
      expect(@current_page.get_expected_data('valid personal login')).to eq('PERSONAL_USERNAME' => 'valid-user')
    end

    it 'will fail when key not found in yml file' do
      expect{ @current_page.get_expected_data('test') }.to raise_exception(RuntimeError)
    end

  end

  context 'get_message' do

    it 'will return specific match from message type from parameter passed in' do
      expect(@current_page.get_message('error messages', 'invalid username')).to eq('You must enter a Valid User ID')
    end

    it 'will return nil when parameter does not match key for given message type' do
      expect(@current_page.get_message('error messages', 'test')).to eq(nil)
    end

  end

  context 'get_color_scheme' do

    it 'will return specific color scheme from parameter passed in' do
      expect(@current_page.get_color_scheme('test')).to eq('Green')
    end

    it 'will return nil when parameter does not match key for given message type' do
      expect(@current_page.get_color_scheme('something')).to eq(nil)
    end

  end

  context 'get_list_values' do

    it 'will return specific color scheme from parameter passed in' do
      expect(@current_page.get_list_values('select list', 'test')).to eq(%w[a b c d])
    end

    it 'will fail when parameter does not match key for given message type' do
      expect{ @current_page.get_list_values('select list', 'something') }.to raise_exception(NoMethodError)
    end

  end

end