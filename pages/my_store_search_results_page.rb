class MyStoreSearchResultsPage < TMAPage


  div(:faded_short_sleeve_shirt, class: 'product-container', text: /Faded Short Sleeve T-shirts/)

  def self.page_title_validation_value
    /Search/i
  end

  def self.page_url_validation_value
    /search/
  end

  def form_field_order
    %w[

    ]
  end
end
