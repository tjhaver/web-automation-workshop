module TMAData
  include DataHelper

  def self.set_tma_object(tma)
    @tma = tma
  end

  def retrieve_data_for(data_value)
    @data[data_value.gsub(' ','_').upcase]
  end

  def load_data_for(data = 'DEFAULT')
    @data = merged_with_default('input_data/' + self.file_name, data.gsub(' ', '_').upcase)

    if @data.size == 0
      raise 'Data set is empty!'
    end

    @data
  end

  def get_expected_data(data_key, message_key = nil, error_on_no_data = true)
    data = merged_with_default('expected_data/' + self.file_name, data_key.gsub(' ','_').upcase, error_on_no_data)

    if message_key
      data = data[message_key.gsub(' ','_').upcase]
    end

    if (data =~ /^\s*lambda/i) != nil
      data = eval(data).call(@tma)
    elsif data.class.to_s == 'Hash'
      data.each do |key, value|
        data[key] = eval(value).call(@tma) if (value =~ /^\s*lambda/i) != nil
      end
    end
    data
  end

  def get_input_data(data_key, message_key = nil)
    data = merged_with_default('input_data/' + self.file_name, data_key.gsub(' ','_').upcase)

    if message_key
      data = data[message_key.gsub(' ','_').upcase]
    end

    if (data =~ /^\s*lambda/i) != nil
      data = eval(data).call(@tma)
    elsif data.class.to_s == 'Hash'
      data.each do |key, value|
        data[key] = eval(value).call(@tma) if (value =~ /^\s*lambda/i) != nil
      end
    end
    data
  end

  def get_message(message_type, message_key)
    get_expected_data("#{message_type.tr(' ','_').upcase}", message_key)
  end

  def get_color_scheme(message_key)
    get_expected_data('COLOR_SCHEME', message_key)
  end

  def get_list_values(parent_key, message_key)
    get_expected_data(parent_key, message_key).split(' | ')
  end

  def self.does_old_data_key_exist?(locator)
    data_files = (get_data_from_yml_file('input_data/' + self.file_name)[locator] || {} )
    (data_files.size) > 0
  end

  protected
  def merged_with_default(path_to_file, key=nil, error_on_no_data=true)
    verbose_messages(key, TMAData.merged_with_default(path_to_file, key, error_on_no_data))
    TMAData.merged_with_default(path_to_file, key, error_on_no_data)
  end

  def self.merged_with_default(path_to_file, key=nil, error_on_no_data=true)
    mandatory = {}

    if key
      all_states = (get_value_from_list_of_keys(get_data_from_yml_file(path_to_file), key) || {})
    else
      all_states = (get_data_from_yml_file(path_to_file) || {})
    end

    merged_data = all_states.clone.merge(mandatory)

    if error_on_no_data and (merged_data.size - mandatory.size) <= 0
      raise "No data elements found; is there a matching key in the YAML for the following key: \n#{key}"
    end

    merged_data
  end

  def self.recursively_merge_hashes(value1, value2)
    if value1.class == Hash and value2.class == Hash
      value1.merge(value2){|v1, v2| recursively_merge_hashes(v1, v2) }
    elsif value1.class != Hash and value2.class != Hash
      value2
    else
      raise "Both elements must either be hashes or something else! #{value1.inspect} vs #{value2.inspect}"
    end
  end

end