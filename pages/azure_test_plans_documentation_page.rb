class AzureTestPlansDocumentationPage < TMAPage

  page_url("https://docs.microsoft.com/en-us/azure/devops/test/?view=azure-devops")

  link(:download_pdf, href: /toc\.pdf/)


  def self.page_title_validation_value
    //
  end

  def self.page_url_validation_value
    /test/
  end

  def form_field_order
    %w[

    ]
  end

end