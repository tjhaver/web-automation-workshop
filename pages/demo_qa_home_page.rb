class DemoQaHomePage < TMAPage

  page_url("https://demoqa.com/")

  div(:elements_card, class: /top-card/, text: /Elements/)

  def self.page_title_validation_value
    /QA/i
  end

  def self.page_url_validation_value
    /demoqa/
  end

  def form_field_order
    %w[

    ]
  end
end
