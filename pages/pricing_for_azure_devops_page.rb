class PricingForAzureDevopsPage < TMAPage

  page_url("https://azure.microsoft.com/en-us/pricing/details/devops/azure-devops-services/")

  link(:azure_pipelines_start_free, text: 'Start free', href: /acom~azure~pipelines~pricing/)
  div(:azure_pipelines_service, xpath: '//*[@id="main"]/section[2]/div[1]/div[1]/div/div/div[1]/div[1]')
  div(:azure_artifacts_service, xpath: '//*[@id="main"]/section[2]/div[1]/div[1]/div/div/div[1]/div[4]')
  div(:basic_plan_licenses, xpath: '//*[@id="main"]/section[2]/div[1]/div[2]/div/div/div[1]/div[1]')
  div(:basic_plus_test_plans_licenses, xpath: '//*[@id="main"]/section[2]/div[1]/div[2]/div/div/div[1]/div[3]')

  def self.page_title_validation_value
    //
  end

  def self.page_url_validation_value
    /azure-devops-services/
  end

  def form_field_order
    %w[

    ]
  end

end