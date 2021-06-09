ROOT_DIR ||= File.join(File.dirname(__FILE__), '..')
require 'date'

EXCLUDED_DIRS = %w[. ..]

def output_folder
  ENV['output_folder'] || File.join(ROOT_DIR, 'output')
end

def nuke_output_directory
  (Dir.entries(output_folder) - EXCLUDED_DIRS).each{|f| Date.parse(f) < Date.today - 30 ? FileUtils.rm_rf("#{output_folder}/#{f}") : return}
end

def cleanup_files
  Dir["#{output_folder}/*.*"].each {|file| FileUtils.remove(file)}
end

cleanup_files
nuke_output_directory