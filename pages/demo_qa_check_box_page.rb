class DemoQaCheckBoxPage < TMAPage

  page_url("https://demoqa.com/checkbox")

  span(:home, xpath: '//*[@id="tree-node"]/ol/li/span/label/span[1]')
  button(:toggle_home, class: /rct-collapse-btn/)

  def self.page_title_validation_value
    //i
  end

  def self.page_url_validation_value
    /checkbox/
  end

  def form_field_order
    %w[

    ]
  end
end
