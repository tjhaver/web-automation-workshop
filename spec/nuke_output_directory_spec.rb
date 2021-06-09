require 'spec_helper'
require 'lib/nuke_output_directory'

describe 'nuke_output_directory' do

  context 'nuke_output_directory' do
    before(:all) do
      (1..30).each { |x| FileUtils.makedirs("#{output_folder}/#{((Date.today - 25) - x).strftime('%Y-%m-%d')}") }
      File.open("#{output_folder}/blah.txt", 'w+'){ p 'testing'}

      cleanup_files
      nuke_output_directory
    end

    after(:all) do
      Dir.entries(output_folder).drop(2).each { |folder| FileUtils.rmdir("#{output_folder}/#{folder}") }
    end

    it 'will keep directories not older than thirty days' do
      expect(Dir.entries(output_folder).drop(2).first).to eq((Date.today - 30).strftime('%Y-%m-%d'))
    end

    it 'will remove directories older than thirty days' do
      expect(Dir.entries(output_folder).drop(2).count { |folder| Date.parse(folder) < Date.today - 30 }).to eq(0)
    end

    it 'will cleanup all files in the root of output directory' do
      expect(File.exists?("#{output_folder}/blah.txt")).to eq(false)
    end
  end
end