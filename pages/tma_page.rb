class TMAPage
  include PageObject
  include TMAData

  def page_title_is_correct
    ( text =~ self.class.page_title_validation_value ) !=nil
  end

  def page_url_is_correct
    ( current_url =~ self.class.page_url_validation_value ) !=nil
  end

  def file_name
    file_name_for(self.class)
  end

  def instantiate_page_data_object(data_key)
    @fillable_form_fields = form_field_order
    self.load_data_for(data_key)
  end

  def fill_all_form_data
    verbose_messages(@fillable_form_fields)

    @fillable_form_fields.each do |field|
      value = self.retrieve_data_for(field)
      enter_element_value(field, value) if value and (value != 'nil')
    end
  end

  def enter_element_value(original_field, value)
    field = original_field.downcase.tr(' ', '_')
    unless self.respond_to? field + '_element'
      warn "undefined method '#{field + '_element'}' for #{@current_page.class}"
      return
    end

    field_type = self.send(field + '_element').class.to_s
    verbose_messages(field_type, field, value)

    if value.class.to_s == 'Array'
      value = eval(value[0]).call(:param_string => value[1], :current_page => self, :repeatable_field_index => value[2])
    end

    formatted_value = value.to_s.downcase.tr(' ', '_')
    return if value.nil? or (value == 'nil')

    keep_trying_to_set(1) do
      case field_type
        when /select/i
          Watir::Wait.until(timeout: 10) {self.send(field + '_element').exists?}
          return if self.send(field.downcase.tr(' ', '_')) == value and value != 'Please Select'
          self.send(field + '=', value)
        when /text/i
          Watir::Wait.until(timeout: 10) {self.send(field + '_element').exists?}
          return if self.send(field) == value and value != ''
          self.send(field + '=', value)
        when /checkbox/i
          Watir::Wait.until(timeout: 10) {self.send(field + '_element').exists?}
          self.send(value.downcase + '_' + field)
        when /radio/i
          Watir::Wait.until(timeout: 10) { self.send( field + '_' + formatted_value + '_element' ).exists? }
          self.send( 'select_' + field + '_' + formatted_value )
        else
          raise('Unknown field type:' + field_type)
      end
    end
  end

  def confirm_element_value(original_field, value)
    field = original_field.downcase.tr(' ', '_')
    unless self.respond_to? field + '_element'
      warn "undefined method '#{field + '_element'}' for #{@current_page.class}"
      return
    end

    field_type = self.send(field + '_element').class.to_s
    verbose_messages(field_type, field, value)

    case field_type
      when /radio/i
        value = (value == 'selected' ? true : false)
        self.send("#{field}_selected?") == value
      when /link/i
        self.send(field).text == value
      when /checkbox/i
        value = (value == 'checked' ? true : false)
        self.send("#{field}_checked?") == value
      when /select/i
        self.send("#{field}_options").include?(value)
      else
        value = (value == 'blank' ? '' : value)
        self.send(field).strip == value
    end
  end

  def get_select_list_options(select_list_name, ignore = '')
    self.send("#{select_list_name}_element").options.to_a.select {|option| option.text !~ /^(#{ignore})/i}
  end

  def radio_list_for_group(radio_label_name)
    self.send(radio_label_name.tr(' ','_').downcase + '_element').parent.radios
  end

  def navigate_back
    self.send('previous_page_element').click
  end

end