class MyStoreHomePage < TMAPage

  page_url("http://automationpractice.com/index.php")

  text_field(:search_field, id: 'search_query_top')
  button(:submit_search, class: /button-search/, text: /Search/)

  def self.page_title_validation_value
    //i
  end

  def self.page_url_validation_value
    /automationpractice/
  end

  def form_field_order
    %w[
        search_field
    ]
  end
end
