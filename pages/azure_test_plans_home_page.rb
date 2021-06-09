class AzureTestPlansHomePage < TMAPage

  page_url("https://azure.microsoft.com/en-us/services/devops/test-plans/")

  link(:pricing, href: "/en-us/pricing/details/devops/")


  def self.page_title_validation_value
    //
  end

  def self.page_url_validation_value
    /test-plans/
  end

  def form_field_order
    %w[

    ]
  end

end