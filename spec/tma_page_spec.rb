require 'spec_helper'

describe 'tma_page' do

  context 'page_title_is_correct' do

    it 'will validate the page we are on by title on page' do
      expect(@current_page.page_title_is_correct).to eq(true)
    end

  end

  context 'page_url_is_correct' do

    it 'will validate the page we are on by url' do
      expect(@current_page.page_url_is_correct).to eq(true)
    end
  end

  context 'file_name' do

    it 'will return the yml file name that matches for the string passed in' do
      expect(@current_page.file_name).to eq('sample_page_data.yml')
    end

  end

  context 'instantiate_page_data_object' do

    it 'will return object with keys present' do
      expect(@current_page.instantiate_page_data_object('valid personal login')).to eq({'PERSONAL_USERNAME' => 'valid-user', 'PERSONAL_PASSWORD' => 'valid-password'})
    end

  end

end