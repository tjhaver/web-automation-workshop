require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'
require 'rspec/core/rake_task'

module RakeProfileHelper

  def self.setup_profile(task, name)
    task.profile = name
    load_environment
    Dir.mkdir(output_folder) unless File.exists?(output_folder)
    task.cucumber_opts = "--retry #{rerun} --guess --color --verbose #{ignore_extensions} --format json --out output/cucumber.json  --format junit --out output --format html --out '#{output_folder + html_name}.html' #{and_tags} #{or_tags} #{strict_mode}"
  end

  def self.load_environment
    ENV['TIMESTAMP'] ||= Time.now.strftime '%Y-%m-%d_%H-%M-%S'
    ENV['opsys'].nil? ? (ENV['opsys'] = 'NA') : (ENV['opsys'] = ENV['opsys'].gsub(' ','_'))
    ENV['device'].nil? ? (ENV['device'] = 'NA') : (ENV['device'] = ENV['device'].gsub(' ','_'))
    ENV['browser_type'].nil? ? (ENV['browser_type'] = 'chrome') : (ENV['browser_type'] = ENV['browser_type'].gsub(' ','_'))
    ENV['app_env'].nil? ? (ENV['app_env'] = 'QA') : (ENV['app_env'] = ENV['app_env'].gsub(' ','_'))
  end

  def self.output_folder
    ENV['output_folder'].nil? ? "output/#{ENV['TIMESTAMP'][0,10]}/" : "#{ENV['output_folder']}/#{ENV['TIMESTAMP'][0,10]}/"
  end

  def self.html_name
    "AutomationReport-BROWSER#{ENV['browser_type']}-ENV#{ENV['app_env']}-OS#{ENV['opsys']}-DEVICE#{ENV['device']}-#{ENV['TIMESTAMP']}"
  end

  def self.rerun
    ENV['rerun'].nil? ? 0 : ENV['rerun']
  end

  def self.ignore_extensions
    %w{
      html htm yml jpg JPG tif bmp png doc docx xls xml pdf txt dot bat PNG mdb zip
    }.inject(' '){|str, ext| str += "--exclude \\.#{ext} "}
  end

  def self.and_tags
    ENV['and_tags'].to_s.split(',').inject(''){
        |str, tag| str += tag.strip.index('~') == 0 ? (" --tags 'not @#{tag.strip.delete('~')}' ") : (" --tags '@#{tag.strip}' ")
    }
  end

  def self.or_tags
    if ENV['or_tags'].nil?
      ''
    else
      or_tags_array = ENV['or_tags'].split(',').inject([]) {|arr,tag| arr << '@' + tag.strip; arr}
      " --tags '#{or_tags_array.join(' or ')}'"
    end
  end

  def self.strict_mode
    case ENV['strict']
      when /^strict/i
        '--strict'
      when /no.*strict/i
        '--no-strict'
      when /^undefined/i
        '--strict-undefined'
      when /no.*undefined/i
        '--no-strict-undefined'
      when /^pending/i
        '--strict-pending'
      when /no.*pending/i
        '--no-strict-pending'
      when /^flaky/i
        '--strict-flaky'
      when /no.*flaky/i
        '--no-strict-flaky'
      else
        '--no-strict'
    end
  end

  def self.execute_multiple_browsers(browsers)
    begin
      ENV['browser_type'] = browsers[0]
      browsers.delete(ENV['browser_type'])
      Rake::Task['features:default'].execute
    ensure
      execute_multiple_browsers(browsers) if browsers.size > 0
    end
  end

end

namespace :features do

  Cucumber::Rake::Task.new(:default, 'Run features with Default task') do |t|
    RakeProfileHelper.setup_profile(t, 'default')
  end

  Cucumber::Rake::Task.new(:run, 'Run features with run task') do |t|
    RakeProfileHelper.setup_profile(t, 'run')
  end

  Cucumber::Rake::Task.new(:regression, 'Run features with regression task') do |t|
    RakeProfileHelper.setup_profile(t, 'regression')
  end

  Cucumber::Rake::Task.new(:jenkins, 'Run features with Jenkins task') do |t|
    RakeProfileHelper.setup_profile(t, 'jenkins')
  end

  task :multiple_browser do
    browsers = ENV['browser_type'].to_s.gsub(' ','').split(',')
    RakeProfileHelper.execute_multiple_browsers(browsers)
  end
end

namespace :rspec do
  RSpec::Core::RakeTask.new(:environment) do |t|
    t.pattern = './spec/*_spec.rb'
    t.rspec_opts = '--no-drb -r rspec_junit_formatter --format RspecJunitFormatter -o output/results.xml'
  end
end