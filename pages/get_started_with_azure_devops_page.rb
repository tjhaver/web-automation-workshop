class GetStartedWithAzureDevopsPage < TMAPage

  text_field(:project_name, id: '__bolt-textfield-input-1')

  def self.page_title_validation_value
    /Signup/
  end

  def self.page_url_validation_value
    /signup/
  end

  def form_field_order
    %w[

    ]
  end

end