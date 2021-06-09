class DemoQaElementsPage < TMAPage

  page_url("https://demoqa.com/elements")

  li(:elements_check_box, id: 'item-1', text: /Check Box/)

  def self.page_title_validation_value
    //i
  end

  def self.page_url_validation_value
    /elements/
  end

  def form_field_order
    %w[

    ]
  end
end
