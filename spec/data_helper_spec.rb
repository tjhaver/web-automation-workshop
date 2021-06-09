require 'spec_helper'

describe 'data_helper' do

  context 'make_const' do

    it 'will make a string look more like a constant' do
      expect(make_const('test test')).to eq('TEST_TEST')
    end

  end

  context 'make_sym' do

    it 'will turn basic string to snake cased symbol' do
      expect(make_symbol('TEST this STRING')).to eq(:test_this_string)
    end

  end

  context 'application_environment' do

    it 'will return env' do
      ENV['app_env'] = 'dev'
      expect(application_environment.downcase).to eq('dev')
    end

  end

  context 'verbose_messages' do

    it 'will print verbose messages when verbose is defined in env' do
      ENV['verbose'] = 'true'
      expect(verbose_messages).to eq([])
    end

  end

  context 'get_data_from_yml_file' do

    it 'will return info from .yml' do
      expect(get_data_from_yml_file('environment_urls.yml').each_key.count).to be > 0
    end

    it 'will return empty hash if .yml file not found' do
      expect(get_data_from_yml_file('does_not_exist.yml')).to eq({})
    end

  end

  context 'output_folder' do

    it 'will return a specified output folder' do
      ENV['output_folder'] = 'test_output_folder'
      expect(output_folder).to eq 'test_output_folder'
    end

    it "will return 'output' if no output folder is specified" do
      ENV['output_folder'] = nil
      expect(output_folder).to eq("#{ROOT_DIR}/output")
    end

  end

end