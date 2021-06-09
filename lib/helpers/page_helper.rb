module PageHelper

  def elementify(element)
    @current_page.send("#{element.tr(' ','_').downcase}_element")
  end

  def page_class_name_for(page_name)
    verbose_messages(page_name)
    Kernel.const_get(page_name.split(' ').collect { |a| (a =~ /\ATMA\z/i ? a.upcase : a.capitalize ) }.join('') + 'Page')
  end

  def file_name_for(page_name)
    page_name = page_class_name_for(page_name) unless page_name.is_a?(Class)
    "#{page_name.to_s.split(/(?=[A-Z])/).collect{ |word| word.downcase }.join('_')}_data.yml"
  end

  def application_is_on_page?(page_names)
    page_name_array = page_names.split(' or ')
    page_correct = false

    page_name_array.each do |page_name|
      page_name = page_name.split(' ').map {|w| w.capitalize }.join(' ') unless page_name == 'TMA'

      on_page(page_class_name_for(page_name))

      if @current_page.page_title_is_correct and @current_page.page_url_is_correct
        page_correct = true
        break
      end
    end
    page_correct
  end

  def keep_trying_to_set(times_to_retry = 10)
    times_to_retry.to_i.times {
      begin
        yield
        return
      rescue Exception => e
        verbose_messages(e)
      end
    }
  end

end