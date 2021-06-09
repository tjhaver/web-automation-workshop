class GoogleHomePage < TMAPage

  page_url("https://www.google.com/")

  text_field(:search_field, class: 'gLFyf gsfi')
  button(:google_search, class: 'gNO89b')
  button(:im_feeling_lucky, id: 'gbqfbb')


  def self.page_title_validation_value
    /Google/i
  end

  def self.page_url_validation_value
    /google/
  end

  def form_field_order
    %w[
        search_field
    ]
  end
end
