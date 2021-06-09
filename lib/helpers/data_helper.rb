module DataHelper

  def application_environment
    ENV['app_env'].nil? ? 'PROD' : ENV['app_env'].gsub(' ','_').upcase
  end

  def output_folder
    ENV['output_folder'] || File.join(ROOT_DIR, 'output')
  end

  def verbose_messages(*args)
    ENV['verbose'] = 'false' unless ENV['verbose'] =~ /true|false/
    verbose_messages('no message available') if args.empty?
    args.each { |message| p message if ENV['verbose'] == 'true' }
  end

  def get_data_from_yml_file(file_path)
    begin
      YAML.load(ERB.new(File.read("#{DATA_SOURCE_DIR}/" + file_path)).result)
    rescue Errno::ENOENT
      Hash.new({})
    end
  end

  def load_capabilities_from_yml(key)
    get_data_from_yml_file('capabilities.yml')[key]
  end

  def get_value_from_list_of_keys(h, keys)
    [keys].flatten.inject(h) {|search_hash, key| search_hash[key] || {} }
  end

  def self.include(file_path)
    begin
      ERB.new(IO.read(DATA_SOURCE_DIR + file_path)).result
    rescue Errno::ENOENT => e
      verbose_messages(e.message)
    end
  end

  def make_symbol(string)
    string.tr(' ','_').downcase.intern
  end

  def make_const(string)
    string.tr(' ','_').upcase
  end

end